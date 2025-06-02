package notice.project.posts.service;

import notice.project.posts.DTO.BoardResponse;
import notice.project.exceptions.UserNotFoundException;
import notice.project.posts.DTO.PageResponse;

import java.sql.SQLException;
import java.util.List;

public interface IBoardService {
    PageResponse<BoardResponse> getPostListWithPagination(int currentPage, int pageSize, int totalButtons) throws SQLException, UserNotFoundException;
    PageResponse<BoardResponse> searchPostsWithPagination(String keyword, String type, int currentPage, int pageSize, int totalButtons) throws SQLException;

}
