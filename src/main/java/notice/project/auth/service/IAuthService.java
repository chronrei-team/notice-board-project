package notice.project.auth.service;

import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.InvalidUserNameException;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;

public interface IAuthService {
    Users verifyLogin(String id, String password) throws SQLException, UserNotFoundException, InvalidPasswordException;
    void register(String userName, String password) throws SQLException, AlreadyRegistedException, InvalidUserNameException;
}
