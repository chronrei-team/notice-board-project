package notice.project.example.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.Posts;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ExampleBoardRepository extends BaseRepository {
    List<Posts> list = new ArrayList<>();
    public List<Posts> findAll() throws SQLException {
        try (QueryResult query = executeQuery("SELECT * FROM Posts ORDER BY createdAt DESC")) {
            var rs = query.Set;
            if (rs.next()) {
                Posts post = new Posts();
                post.id = rs.getInt("id");
                post.userId = rs.getString("userId");
                post.title = rs.getString("title");
                post.content = rs.getString("content");
                post.createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                post.updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                post.viewCount = rs.getInt("viewCount");
                post.recommendCount = rs.getInt("recommendCount");
                list.add(post);
            }
        }
        return list;
    }
}
