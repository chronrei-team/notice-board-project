package notice.project.posts.service;

import notice.project.posts.DTO.BoardResponse;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.List;

public interface IBoardService {
    List<BoardResponse> getPostList() throws SQLException, UserNotFoundException;
}
