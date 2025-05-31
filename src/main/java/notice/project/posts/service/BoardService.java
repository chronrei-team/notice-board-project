package notice.project.posts.service;

import notice.project.core.Transactional;
import notice.project.posts.DTO.BoardResponse;
import notice.project.posts.DTO.PageResponse;
import notice.project.posts.repository.BoardRepository;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardService implements IBoardService {
    private final BoardRepository repo;

    public BoardService(BoardRepository repo) {
        this.repo = repo;
    }

    @Override
    @Transactional
    public List<BoardResponse> getPostList(int page, int pageSize) throws SQLException, UserNotFoundException {

        return repo.findAll(page, pageSize);
    }

    @Override
    @Transactional
    public List<BoardResponse> getPostListForPagination(int currentPage, int pageSize, int maxPagesToCheck) throws SQLException {
        int offset = (currentPage - 1) * pageSize;
        int limit = pageSize * maxPagesToCheck;
        return repo.findAllRaw(offset, limit);
    }

    @Override
    @Transactional
    public List<BoardResponse> getPostListExtra(int offset, int limit) throws SQLException, UserNotFoundException {
        return repo.findAllRaw(offset, limit);
    }

    @Override
    @Transactional
    public PageResponse<BoardResponse> getPostListWithPagination(int currentPage, int pageSize, int totalButtons) throws SQLException, UserNotFoundException {
        // 1. 기본 게시글 목록 조회 (현재 페이지)
        List<BoardResponse> currentPagePosts = getPostList(currentPage, pageSize);

        // 2. 최대 오른쪽 페이지 수
        int extraPageCount = totalButtons - 1; // 총 버튼 개수 - 현재 페이지 버튼

        // 3. 오른쪽 추가 게시글 조회 (현재 페이지 다음 글들)
        int extraOffset = currentPage * pageSize;
        int extraLimit = pageSize * extraPageCount;
        List<BoardResponse> extraPosts = getPostListExtra(extraOffset, extraLimit);

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
            int toIndex = Math.min(fromIndex + pageSize, extraPosts.size());
            if (toIndex - fromIndex == pageSize) {
                rightButtonsCount++;
            } else {
                break;
            }
        }

        // 6. 최대 허용 endPage 재설정
        endPage = Math.min(endPage, currentPage + rightButtonsCount);

        // 7. startPage 재조정 (totalButtons 개수 유지)
        startPage = Math.max(1, endPage - totalButtons + 1);

        return new PageResponse<>(currentPagePosts, currentPage, startPage, endPage, totalButtons);
    }
}
