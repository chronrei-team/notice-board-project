package notice.project.admin.service;

import notice.project.admin.DTO.UserResponse;
import notice.project.admin.repository.AdminRepository;
import notice.project.core.Transactional;
import notice.project.entity.UserStatus;
import notice.project.entity.UserSuspend;

import java.sql.SQLException;
import java.time.LocalDateTime;
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

    @Override
    @Transactional
    public void suspendUser(String userId, LocalDateTime suspendedEndAt, String reason) throws SQLException {
        var suspend = adminRepository.getUserSuspend(userId);
        if (suspend == null) {
            suspend = new UserSuspend();
            suspend.id = userId;
            suspend.suspendedEndAt = suspendedEndAt;
            suspend.reason = reason;
            suspend.suspendedAt = LocalDateTime.now();
            adminRepository.add(suspend);
        }
        else {
            suspend.suspendedEndAt = suspendedEndAt;
            suspend.reason = reason;
            suspend.suspendedAt = LocalDateTime.now();
            adminRepository.update(suspend);
        }
        adminRepository.updateStatus(UserStatus.Suspended, userId);
    }
}
