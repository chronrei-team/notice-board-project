package notice.project.my.service;

import notice.project.entity.Users;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;

public interface IMyService {
    Users profileUpdate(String originalUserName, String newUserName, String originalPassword, String newPassword) throws SQLException, NoSuchAlgorithmException, InvalidKeySpecException;
    void withdrawUser(String userName, String password) throws SQLException, NoSuchAlgorithmException, InvalidKeySpecException;
}
