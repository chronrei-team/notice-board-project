package notice.project.admin.service;

import notice.project.admin.DTO.UserResponse;

import java.sql.SQLException;
import java.util.ArrayList;

public interface IAdminService {
    ArrayList<UserResponse> getUsers(String name) throws SQLException;
}
