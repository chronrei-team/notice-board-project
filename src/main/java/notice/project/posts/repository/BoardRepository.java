package notice.project.posts.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.PostCategory;
import notice.project.posts.DTO.BoardResponse;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BoardRepository extends BaseRepository {
    public List<BoardResponse> findAll(int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        return findAllRaw(offset, pageSize);
    }

    public List<BoardResponse> findAllRaw(int offset, int limit) throws SQLException {
        List<BoardResponse> list = new ArrayList<>();
        String sql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId" +
                " from Posts p, users u where p.userId=u.id order by p.createdAt desc limit ? offset ?";
        try (QueryResult query = executeQuery(sql, limit, offset)) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory category = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        category = PostCategory.valueOf(categoryStr); // 문자열을 enum으로 변환
                    } catch (IllegalArgumentException e) {
                        // 예외 처리 (알 수 없는 enum 값): 로그 출력 or 기본값 사용
                        category = PostCategory.Normal; // 예: 기본값 지정
                    }
                }


                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), category
                ));
            }
        }
        return list;
    }

    public List<BoardResponse> searchByKeyword(String keyword, String type, int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        List<BoardResponse> list = new ArrayList<>();

        String baseSql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId " +
                "from Posts p, users u where p.userId=u.id ";

        String whereSql = "";
        if (keyword != null && !keyword.isEmpty()) {
            switch (type) {
                case "title":
                    whereSql = " and p.title like ? ";
                    break;
                case "content":
                    whereSql = " and p.content like ? ";
                    break;
                case "author":
                    whereSql = " and u.userName like ? ";
                    break;
                default:
                    whereSql = " and p.title like ? ";
                    break;
            }
        }

        String orderLimitSql = " order by p.createdAt desc limit ? offset ?";

        String sql = baseSql + whereSql + orderLimitSql;

        try (QueryResult query = (keyword != null && !keyword.isEmpty())
                ? executeQuery(sql, "%" + keyword + "%", pageSize, offset)
                : executeQuery(sql, pageSize, offset)) {

            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory category = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        category = PostCategory.valueOf(categoryStr); // 문자열을 enum으로 변환
                    } catch (IllegalArgumentException e) {
                        // 예외 처리 (알 수 없는 enum 값): 로그 출력 or 기본값 사용
                        category = PostCategory.Normal; // 예: 기본값 지정
                    }
                }

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), category
                ));
            }
        }

        return list;
    }

    public int countByKeyword(String keyword, String type) throws SQLException {
        int count = 0;

        String baseSql = "SELECT COUNT(*) FROM Posts p, users u WHERE p.userId = u.id ";
        String whereSql = "";

        if (keyword != null && !keyword.isEmpty()) {
            switch (type) {
                case "title":
                    whereSql = " AND p.title LIKE ? ";
                    break;
                case "content":
                    whereSql = " AND p.content LIKE ? ";
                    break;
                case "author":
                    whereSql = " AND u.userName LIKE ? ";
                    break;
                default:
                    whereSql = " AND p.title LIKE ? ";
                    break;
            }
        }

        String sql = baseSql + whereSql;

        try (QueryResult query = (keyword != null && !keyword.isEmpty())
                ? executeQuery(sql, "%" + keyword + "%")
                : executeQuery(sql)) {

            var rs = query.Set;
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }

        return count;
    }

}
