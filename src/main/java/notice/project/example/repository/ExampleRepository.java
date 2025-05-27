package notice.project.example.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.Users;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class ExampleRepository extends BaseRepository {
    public Users findBy(String id) throws SQLException {
        try (QueryResult query = executeQuery("SELECT * FROM Users WHERE id = ?", id)) {
            var rs = query.Set;
            if (rs.next()) {
                return new Users(
                        rs.getString("id"),
                        rs.getString("passwordHash"),
                        LocalDateTime.parse(rs.getString("createdAt")),
                        rs.getString("updatedAt") != null
                                ? LocalDateTime.parse(rs.getString("updatedAt"))
                                : null,
                        rs.getString("lastLoginAt") != null
                                ? LocalDateTime.parse(rs.getString("lastLoginAt"))
                                : null,
                        rs.getString("deletedAt") != null
                                ? LocalDateTime.parse(rs.getString("deletedAt"))
                                : null,
                        rs.getString("status"),
                        rs.getString("userName"),
                        rs.getString("role"),
                        null,
                        null
                );
            }
            return null;
        }
    }
}
