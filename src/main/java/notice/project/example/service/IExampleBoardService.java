package notice.project.example.service;

import notice.project.example.DTO.ExampleBoardResponse;
import notice.project.example.DTO.ExamplePassword;
import notice.project.example.DTO.ExampleResponse;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.List;

public interface IExampleBoardService {
    List<ExampleBoardResponse> getPostList() throws SQLException, UserNotFoundException;
}
