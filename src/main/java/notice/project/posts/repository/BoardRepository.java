package notice.project.posts.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.posts.DTO.BoardResponse;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BoardRepository extends BaseRepository {
    public List<BoardResponse> findAll(int page, int pageSize) throws SQLException {
        List<BoardResponse> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "select p.*, u.userName from Posts p, users u where p.userId=u.id order by p.createdAt desc limit ? offset ?;";
        try (QueryResult query = executeQuery(sql, pageSize, offset)) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName")
                ));
            }
        }
        return list;
    }
    public int countAll() throws SQLException {
        String sql = "select count(*) as total from Posts";
        try (var query = executeQuery(sql)) {
            var rs = query.Set;
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
}
