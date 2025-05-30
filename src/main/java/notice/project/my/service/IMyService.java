package notice.project.my.service;

import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.InvalidUserNameException;
import notice.project.exceptions.UserNotFoundException;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;

public interface IMyService {
    Users profileUpdate(String originalUserName, String newUserName, String originalPassword, String newPassword) throws InvalidUserNameException, SQLException, UserNotFoundException, NoSuchAlgorithmException, InvalidKeySpecException, AlreadyRegistedException, InvalidPasswordException;
}
