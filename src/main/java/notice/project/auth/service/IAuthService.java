package notice.project.auth.service;

import notice.project.auth.DTO.LoginResponse;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;

public interface IAuthService {
    LoginResponse verifyLogin(String id, String password) throws SQLException, UserNotFoundException, InvalidPasswordException;
    void register(String userName, String password) throws SQLException, AlreadyRegistedException;
}
