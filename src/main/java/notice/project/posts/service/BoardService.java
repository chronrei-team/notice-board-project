package notice.project.posts.service;

import notice.project.auth.DTO.Token;
import notice.project.core.Transactional;
import notice.project.entity.Comments;
import notice.project.entity.UserRole;
import notice.project.posts.DTO.*;
import notice.project.posts.repository.BoardRepository;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

public class BoardService implements IBoardService {
    private final BoardRepository repo;

    public BoardService(BoardRepository repo) {
        this.repo = repo;
    }

    @Override
    @Transactional
    public PageResponse<BoardResponse> getPostListWithPagination(String category, int currentPage, int pageSize, int totalButtons) throws SQLException, UserNotFoundException {
        List<BoardResponse> fixedNotices = repo.findFixedNotices();

        // 1. 기본 게시글 목록 조회 (현재 페이지)
        List<BoardResponse> currentPagePosts = repo.findAll(category, currentPage, pageSize);

        // 2. 최대 오른쪽 페이지 수
        int extraPageCount = totalButtons - 1; // 총 버튼 개수 - 현재 페이지 버튼

        // 3. 오른쪽 추가 게시글 조회 (현재 페이지 다음 글들)
        int extraOffset = currentPage * pageSize;
        int extraLimit = pageSize * extraPageCount;
        List<BoardResponse> extraPosts = repo.findAllRaw(category, extraOffset, extraLimit);

        int half = totalButtons / 2;

        // 4. 페이지네이션 시작/끝 페이지 계산
        int startPage = currentPage - half;
        int endPage = currentPage + half;

        if (startPage < 1) {
            endPage += 1 - startPage;
            startPage = 1;
        }

        // 5. 오른쪽 페이지 수 보정 (extraPosts 크기 기준)
        int rightButtonsCount = 0;
        for (int i = 0; i < extraPageCount; i++) {
            int fromIndex = i * pageSize;
            if (fromIndex < extraPosts.size()) {
                rightButtonsCount++;
            } else {
                break;
            }
        }

        // 6. 최대 허용 endPage 재설정
        endPage = Math.min(endPage, currentPage + rightButtonsCount);

        // 7. startPage 재조정 (totalButtons 개수 유지)
        startPage = Math.max(1, endPage - totalButtons + 1);

        return new PageResponse<>(fixedNotices, currentPagePosts, currentPage, startPage, endPage, totalButtons);
    }

    @Override
    @Transactional
    public PageResponse<BoardResponse> searchPostsWithPagination(String keyword, String type, String op, String category, int currentPage, int pageSize, int totalButtons) throws SQLException {
        List<BoardResponse> fixedNotices = repo.findFixedNotices();

        // 1. 현재 페이지 게시글 조회
        List<BoardResponse> currentPagePosts = repo.searchByKeyword(keyword, type, op, category, currentPage, pageSize);

        // 2. 최대 오른쪽 페이지 수
        int extraPageCount = totalButtons - 1; // 총 버튼 개수 - 현재 페이지 버튼

        // 3. 오른쪽 추가 게시글 조회 (현재 페이지 다음 글들)
        int extraOffset = currentPage * pageSize;
        int extraLimit = pageSize * extraPageCount;
        List<BoardResponse> extraPosts = repo.searchByKeywordRaw(keyword, type, op, category, extraOffset, extraLimit);

        int half = totalButtons / 2;

        // 4. 페이지네이션 시작/끝 페이지 계산
        int startPage = currentPage - half;
        int endPage = currentPage + half;

        if (startPage < 1) {
            endPage += 1 - startPage;
            startPage = 1;
        }

        // 5. 오른쪽 페이지 수 보정 (extraPosts 크기 기준)
        int rightButtonsCount = 0;
        for (int i = 0; i < extraPageCount; i++) {
            int fromIndex = i * pageSize;
            if (fromIndex < extraPosts.size()) {
                rightButtonsCount++;
            } else {
                break;
            }
        }

        // 6. 최대 허용 endPage 재설정
        endPage = Math.min(endPage, currentPage + rightButtonsCount);

        // 7. startPage 재조정 (totalButtons 개수 유지)
        startPage = Math.max(1, endPage - totalButtons + 1);

        return new PageResponse<>(fixedNotices, currentPagePosts, currentPage, startPage, endPage, totalButtons);
    }

    @Override
    @Transactional
    public ViewResponse getPostDetail(int postId, Token token) throws SQLException {
        var posts = repo.findPost(postId);

        var comments = new HashMap<Integer, Comment>();
        for (Comments comm : posts.comments) {
            if (comm.parentCommentId == 0) {
                comments.put(comm.id, new Comment(
                        comm.id, comm.userId, comm.writer.userName, comm.content, comm.createdAt, null, new ArrayList<>()
                ));
            }
        }
        for (Comments comm : posts.comments) {
            if (comm.parentCommentId != 0) {
                comments.get(comm.parentCommentId)
                        .getChildren()
                        .add(new Comment(
                                comm.id, comm.userId, comm.writer.userName, comm.content,
                                comm.createdAt, comm.referenceComment.writer.userName, null
                ));
            }
        }

        return new ViewResponse(
                postId,
                posts.title,
                posts.user.userName,
                posts.createdAt,
                posts.viewCount,
                posts.content,
                token != null && (token.getRole() == UserRole.Admin || token.getUserName().equals(posts.user.userName)),
                posts.postFiles.stream().map(f -> new File(f.name, f.url, getFormattedSize(f.size))).toList(),
                comments.values().stream().sorted(Comparator.comparing(Comment::getWrittenAt).reversed()).toList()
        );
    }

    private String getFormattedSize(long size) {
        if (size <= 0) {
            return "0B";
        }

        // 단위를 나타내는 문자열 배열
        final String[] units = new String[] { "B", "KB", "MB", "GB", "TB" };

        // 1024로 몇 번 나눌 수 있는지 계산 (log 연산)
        int digitGroups = (int) (Math.log10(size) / Math.log10(1024));

        // 해당 단위로 파일 크기를 계산하고, 소수점 첫째 자리까지 포맷팅
        return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups))
                + units[digitGroups];
    }
}
