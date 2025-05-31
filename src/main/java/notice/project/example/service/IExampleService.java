package notice.project.example.service;

import notice.project.example.DTO.ExamplePassword;
import notice.project.example.DTO.ExampleResponse;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;

public interface IExampleService {
    ExampleResponse getName(String userId) throws SQLException, UserNotFoundException;
    ExamplePassword getPassword(String userId) throws SQLException, UserNotFoundException;
}
