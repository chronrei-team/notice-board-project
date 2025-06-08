package notice.project.admin.repository;

import notice.project.core.BaseRepository;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.UserSuspend;
import notice.project.entity.Users;

import java.sql.SQLException;
import java.text.MessageFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class AdminRepository extends BaseRepository {
    public ArrayList<Users> getNormalUsers(String userName) throws SQLException {
        var sql = new StringBuilder();
        sql.append("SELECT * FROM users u " +
                "LEFT JOIN user_suspend us ON u.id = us.id " +
                "WHERE role <> '").append(UserRole.Admin.name()).append("' ");
        var params = new ArrayList<Object>();
        if (userName != null && !userName.isEmpty()) {
            sql.append(" AND userName = ? ");
            params.add(userName);
        }

        sql.append("ORDER BY createdAt DESC ");
        var users = new ArrayList<Users>();
        try (var query = executeQuery(sql.toString(), params.toArray())) {
            var rs = query.Set;
            while (rs.next()) {
                var user = new Users();
                user.id = rs.getString("id");
                user.userName = rs.getString("userName");
                user.status = UserStatus.valueOf(rs.getString("status"));
                user.role = UserRole.valueOf(rs.getString("role"));
                user.createdAt = LocalDateTime.parse(rs.getString("createdAt"));
                user.suspend = new UserSuspend();
                user.suspend.id = rs.getString("id");
                if (rs.getString("suspendedAt") != null) {
                    user.suspend.suspendedAt = LocalDateTime.parse(rs.getString("suspendedAt"));
                }
                if (rs.getString("reason") != null) {
                    user.suspend.reason = rs.getString("reason");
                }
                if (rs.getString("suspendedEndAt") != null) {
                    user.suspend.suspendedEndAt = LocalDateTime.parse(rs.getString("suspendedEndAt"));
                }

                users.add(user);
            }
        }
        return users;
    }

    public UserSuspend getUserSuspend(String userId) throws SQLException {
        try (var query = executeQuery("SELECT * FROM user_suspend WHERE id = ?", userId)) {
            var rs = query.Set;
            if (rs.next()) {
                var suspend = new UserSuspend();
                suspend.id = rs.getString("id");
                suspend.reason = rs.getString("reason");
                suspend.suspendedAt = LocalDateTime.parse(rs.getString("suspendedAt"));
                if (rs.getString("suspendedEndAt") != null) {
                    suspend.suspendedEndAt = LocalDateTime.parse(rs.getString("suspendedEndAt"));
                }
                return suspend;
            }
        }
        return null;
    }

    public void add(UserSuspend suspend) throws SQLException {
        executeCommand("INSERT INTO user_suspend " +
                "VALUES(?, ?, ?, ?)", suspend.id, suspend.suspendedAt, suspend.suspendedEndAt, suspend.reason);
    }

    public void update(UserSuspend suspend) throws SQLException {
        executeCommand("UPDATE user_suspend SET suspendedAt = ?, suspendedEndAt = ?, reason = ? " +
                "WHERE id = ?", suspend.suspendedAt, suspend.suspendedEndAt, suspend.reason, suspend.id);
    }

    public void updateStatus(UserStatus status, String userId) throws SQLException {
        executeCommand("UPDATE users SET status = ? WHERE id = ?", status.name(), userId);
    }
}
