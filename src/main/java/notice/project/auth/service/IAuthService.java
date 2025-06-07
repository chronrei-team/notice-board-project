package notice.project.auth.service;

import notice.project.entity.Users;

import java.sql.SQLException;

public interface IAuthService {
    Users verifyLogin(String userName, String password) throws SQLException;
    void register(String userName, String password) throws SQLException;
}
