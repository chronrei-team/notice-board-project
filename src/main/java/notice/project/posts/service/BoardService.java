package notice.project.posts.service;

import notice.project.auth.DTO.Token;
import notice.project.core.Transactional;
import notice.project.entity.Comments;
import notice.project.entity.UserRole;
import notice.project.exceptions.PostNotFountException;
import notice.project.posts.DTO.*;
import notice.project.posts.repository.BoardRepository;
import notice.project.exceptions.UserNotFoundException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

        StringBuilder sb = new StringBuilder();
        if (category != null && !category.isEmpty()) {
            sb.append("&category=").append(URLEncoder.encode(category, StandardCharsets.UTF_8));
        }
        String queryString = sb.toString();

        // --- rightArrowPage 계산 (다음 오른쪽 화살표 이동 페이지) ---
        int rightArrowPage = currentPage + totalButtons;
        int maxMovablePage = calculateMaxMovablePage(category, currentPage, pageSize, 5);
        rightArrowPage = Math.min(rightArrowPage, maxMovablePage);
        // maxMovablePage가 있다면 비교 후 조정하는 로직을 추가할 수 있음
        // ex) int maxMovablePage = calculateMaxMovablePage(...);
        // rightArrowPage = Math.min(rightArrowPage, maxMovablePage);

        return new PageResponse<>(fixedNotices, currentPagePosts, currentPage, startPage, endPage, totalButtons, rightArrowPage, queryString);
    }

    @Override
    @Transactional
    public PageResponse<BoardResponse> searchPostsWithPagination(String keyword, String type, String op, String category,
                                                                 int currentPage, int pageSize, int totalButtons) throws SQLException {
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

        StringBuilder sb = new StringBuilder();
        if (type != null && !type.isEmpty()) {
            sb.append("&type=").append(URLEncoder.encode(type, StandardCharsets.UTF_8));
        }
        if (keyword != null && !keyword.isEmpty()) {
            sb.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
        }
        if (category != null && !category.isEmpty()) {
            sb.append("&category=").append(URLEncoder.encode(category, StandardCharsets.UTF_8));
        }
        if (op != null && !op.isEmpty()) {
            sb.append("&op=").append(URLEncoder.encode(op, StandardCharsets.UTF_8));
        }
        String queryString = sb.toString();

        // --- rightArrowPage 계산 (다음 오른쪽 화살표 이동 페이지) ---
        int rightArrowPage = currentPage + totalButtons;
        int maxMovablePage = calculateMaxMovablePageForSearch(keyword, type, op, category, currentPage, pageSize, 5);
        rightArrowPage = Math.min(rightArrowPage, maxMovablePage);
        // maxMovablePage가 있다면 비교 후 조정하는 로직을 추가할 수 있음
        // ex) int maxMovablePage = calculateMaxMovablePage(...);
        // rightArrowPage = Math.min(rightArrowPage, maxMovablePage);

        return new PageResponse<>(fixedNotices, currentPagePosts, currentPage, startPage, endPage, totalButtons, rightArrowPage, queryString);
    }

    @Override
    @Transactional
    public int calculateMaxMovablePage(String category, int currentPage, int pageSize, int maxMovePageCount) throws SQLException {
        // 조회할 게시글 개수 = (maxMovePageCount * pageSize) + 1
        int fetchCount = maxMovePageCount * pageSize + 1;

        // 현재 페이지 이후 게시글 조회 시작 offset
        int offset = currentPage * pageSize;

        // DB에서 현재 페이지 이후 게시글 일부를 조회 (Raw 쿼리 사용)
        List<BoardResponse> extraPosts = repo.findAllRaw(category, offset, fetchCount);

        // 조회된 게시글 수로 최대 이동 가능한 페이지 계산
        int postCount = extraPosts.size();

        if (postCount == 0) {
            // 더 이상 이동 불가
            return currentPage;
        }

        // 게시글 수가 한 페이지당 게시글 수보다 작으면 한 페이지 이동 가능
        int maxPagesAvailable = postCount / pageSize;

        // 나머지 게시글이 있으면 페이지 수에 1 추가
        if (postCount % pageSize > 0) {
            maxPagesAvailable += 1;
        }

        // 최대 이동 가능 페이지 번호 계산 (현재 페이지 + 최대 이동 가능한 페이지 수, 최대 maxMovePageCount 제한)
        int maxMovablePage = currentPage + Math.min(maxPagesAvailable, maxMovePageCount);

        return maxMovablePage;
    }

    @Override
    @Transactional
    public int calculateMaxMovablePageForSearch(String keyword, String type, String op, String category,
                                                int currentPage, int pageSize, int maxMovePageCount) throws SQLException {
        int fetchCount = maxMovePageCount * pageSize + 1;
        int offset = currentPage * pageSize;

        List<BoardResponse> extraPosts = repo.searchByKeywordRaw(keyword, type, op, category, offset, fetchCount);

        int postCount = extraPosts.size();

        if (postCount == 0) return currentPage;

        int maxPagesAvailable = postCount / pageSize;
        if (postCount % pageSize > 0) maxPagesAvailable += 1;

        return currentPage + Math.min(maxPagesAvailable, maxMovePageCount);
    }

    @Override
    @Transactional
    public ViewResponse getPostDetail(int postId, Token token) throws SQLException, PostNotFountException {
        var posts = repo.findPost(postId);
        if (posts == null) throw new PostNotFountException();

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

        posts.viewCount++;
        repo.updateViewCount(posts);

        return new ViewResponse(
                postId,
                posts.title,
                posts.user.userName,
                posts.createdAt,
                posts.viewCount,
                posts.content,
                token != null && (token.getRole() == UserRole.Admin || token.getUserName().equals(posts.user.userName)),
                posts.postFiles.stream().map(f -> new File(f.name, f.url, getFormattedSize(f.size),
                        f.name.lastIndexOf('.') >= 0
                                ? f.name.toLowerCase().substring(f.name.lastIndexOf('.') + 1)
                                : null
                        )).toList(),
                comments.values().stream().sorted(Comparator.comparing(Comment::getWrittenAt)).toList()
        );
    }

    @Override
    @Transactional
    public void deletePost(int id) throws SQLException {
        repo.delete(id);
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
