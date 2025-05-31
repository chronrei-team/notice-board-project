package notice.project.posts.service;

import notice.project.posts.DTO.BoardResponse;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.List;

public interface IBoardService {
    List<BoardResponse> getPostList(int page, int pageSize) throws SQLException, UserNotFoundException;
    List<BoardResponse> getPostListForPagination(int currentPage, int pageSize, int maxPagesToCheck) throws SQLException;
    List<BoardResponse> getPostListExtra(int offset, int limit) throws SQLException, UserNotFoundException;
}
