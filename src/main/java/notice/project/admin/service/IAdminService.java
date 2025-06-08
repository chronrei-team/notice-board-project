package notice.project.admin.service;

import notice.project.admin.DTO.UserResponse;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;

public interface IAdminService {
    ArrayList<UserResponse> getUsers(String name) throws SQLException;
    void suspendUser(String userId, LocalDateTime suspendedEndAt, String reason) throws SQLException;
    void releaseUser(String userId) throws SQLException;
}
