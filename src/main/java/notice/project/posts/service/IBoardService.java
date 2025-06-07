package notice.project.posts.service;

import notice.project.auth.DTO.Token;
import notice.project.entity.UserRole;
import notice.project.posts.DTO.BoardResponse;
import notice.project.posts.DTO.PageResponse;
import notice.project.posts.DTO.ViewResponse;

import java.sql.SQLException;
import java.util.List;

public interface IBoardService {
    PageResponse<BoardResponse> getPostListWithPagination(String category, int currentPage, int pageSize, int totalButtons) throws SQLException;
    PageResponse<BoardResponse> searchPostsWithPagination(String keyword, String type, String op, String category, int currentPage, int pageSize, int totalButtons) throws SQLException;
    int calculateMaxMovablePage(String category, int currentPage, int pageSize, int maxMovePageCount) throws SQLException;
    int calculateMaxMovablePageForSearch(String keyword, String type, String op, String category, int currentPage, int pageSize, int maxMovePageCount) throws SQLException;
    ViewResponse getPostDetail(int postId, Token token) throws SQLException;
    void deletePost(int id) throws SQLException;
}
