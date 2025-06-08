package notice.project.admin.service;

import notice.project.admin.DTO.UserResponse;
import notice.project.admin.repository.AdminRepository;
import notice.project.core.Transactional;

import java.sql.SQLException;
import java.util.ArrayList;

public class AdminService implements IAdminService {
    private final AdminRepository adminRepository;

    public AdminService(AdminRepository adminRepository) {
        this.adminRepository = adminRepository;
    }

    @Override
    @Transactional
    public ArrayList<UserResponse> getUsers(String name) throws SQLException {
        var users = adminRepository.getNormalUsers(name);
        return users.stream().map(u -> new UserResponse(u.id, u.userName, u.status.toString(), u.createdAt, u.suspend.suspendedEndAt))
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
    }
}
