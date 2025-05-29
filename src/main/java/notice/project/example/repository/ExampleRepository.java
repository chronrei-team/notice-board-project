package notice.project.example.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.Users;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class ExampleRepository extends BaseRepository {
    public Users findBy(String id) throws SQLException {
        try (QueryResult query = executeQuery("SELECT * FROM Users WHERE id = ?", id)) {
            var rs = query.Set;
            if (rs.next()) {
                var user = new Users();
                user.id = rs.getString("id");
                user.passwordHash = rs.getString("passwordHash");
                user.createdAt = LocalDateTime.parse(rs.getString("createdAt"));
                user.updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                user.lastLoginAt = rs.getString("lastLoginAt") != null
                        ? LocalDateTime.parse(rs.getString("lastLoginAt"))
                        : null;
                user.deletedAt = rs.getString("deletedAt") != null
                        ? LocalDateTime.parse(rs.getString("deletedAt"))
                        : null;
                user.status = UserStatus.valueOf(rs.getString("status"));
                user.userName = rs.getString("userName");
                user.role = UserRole.valueOf(rs.getString("role"));

                return user;
            }
            return null;
        }
    }
}
