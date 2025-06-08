package notice.project.admin.repository;

import notice.project.core.BaseRepository;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.Users;

import java.sql.SQLException;
import java.text.MessageFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class AdminRepository extends BaseRepository {
    public ArrayList<Users> getNormalUsers(String userName) throws SQLException {
        var sql = new StringBuilder();
        sql.append("SELECT * FROM users WHERE role <> '").append(UserRole.Admin.name()).append("' ");
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
                user.unsuspended_at = rs.getString("unsuspended_at") != null
                        ? LocalDateTime.parse(rs.getString("unsuspended_at"))
                        : null;
                users.add(user);
            }
        }
        return users;
    }
}
