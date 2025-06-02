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
    public PageResponse<BoardResponse> getPostListWithPagination(int currentPage, int pageSize, int totalButtons) throws SQLException, UserNotFoundException {
        // 1. 기본 게시글 목록 조회 (현재 페이지)
        List<BoardResponse> currentPagePosts = repo.findAll(currentPage, pageSize);

        if (currentPagePosts.isEmpty() && currentPage != 1) {
            throw new IllegalArgumentException("존재하지 않는 페이지입니다.");
            // 또는: return null; 혹은 별도 오류 응답 반환
        }

        // 2. 최대 오른쪽 페이지 수
        int extraPageCount = totalButtons - 1; // 총 버튼 개수 - 현재 페이지 버튼

        // 3. 오른쪽 추가 게시글 조회 (현재 페이지 다음 글들)
        int extraOffset = currentPage * pageSize;
        int extraLimit = pageSize * extraPageCount;
        List<BoardResponse> extraPosts = repo.findAllRaw(extraOffset, extraLimit);

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

    @Override
    @Transactional
    public PageResponse<BoardResponse> searchPostsWithPagination(String keyword, String type, int currentPage, int pageSize, int totalButtons) throws SQLException {
        // 1. 총 게시글 수 조회
        int totalCount = repo.countByKeyword(keyword, type);

        // 2. 총 페이지 수 계산
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) totalPages = 1; // 게시글이 없을 경우에도 페이지 1은 유지

        // 3. 현재 페이지 보정
        if (currentPage > totalPages) {
            currentPage = totalPages;
        } else if (currentPage < 1) {
            currentPage = 1;
        }

        // 4. 현재 페이지 게시글 조회
        int currentOffset = (currentPage - 1) * pageSize;
        List<BoardResponse> currentPagePosts = repo.searchByKeyword(keyword, type, currentOffset, pageSize);

        // 5. 페이지네이션 범위 계산 (totalButtons 개수 내에서)
        int half = totalButtons / 2;
        int startPage = currentPage - half;
        int endPage = currentPage + half;

        if (startPage < 1) {
            endPage += 1 - startPage;
            startPage = 1;
        }

        if (endPage > totalPages) {
            startPage -= endPage - totalPages;
            endPage = totalPages;
            if (startPage < 1) startPage = 1;
        }

        return new PageResponse<>(currentPagePosts, currentPage, startPage, endPage, totalButtons);
    }

}
