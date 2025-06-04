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
    public List<BoardResponse> findAll(String category, int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        return findAllRaw(category, offset, pageSize);
    }

    public List<BoardResponse> findAllRaw(String category, int offset, int limit) throws SQLException {
        List<BoardResponse> list = new ArrayList<>();
        String sql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId " +
                " from Posts p, users u where p.userId=u.id ";
        List<Object> paramList = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            sql += "AND p.category = ? ";
            paramList.add(category);
        }

        sql += "ORDER BY p.createdAt DESC, p.id DESC LIMIT ? OFFSET ?";
        paramList.add(limit);
        paramList.add(offset);

        try (QueryResult query = executeQuery(sql, paramList.toArray())) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory postCategory = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        postCategory = PostCategory.valueOf(categoryStr);
                    } catch (IllegalArgumentException e) {
                        postCategory = PostCategory.Normal;
                    }
                }

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), postCategory
                ));
            }
        }
        return list;
    }

    public List<BoardResponse> searchByKeyword(String keyword, String type, String category, int page, int pageSize) throws SQLException {
        if (page < 1) page = 1;
        int offset = (page - 1) * pageSize;
        List<BoardResponse> list = new ArrayList<>();

        String baseSql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId " +
                " from Posts p, users u where p.userId=u.id ";

        StringBuilder whereSql = new StringBuilder();
        List<Object> paramList = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            whereSql.append(" AND p.category = ? ");
            paramList.add(category);
        }

        if (keyword != null && !keyword.isBlank()) {
            String[] words = keyword.trim().split("\\s+");

            String field;
            boolean isAuthorSearch = false;
            switch (type) {
                case "content":
                    field = "p.content";
                    break;
                case "author":
                    field = "u.userName";
                    isAuthorSearch = true;
                    break;
                case "title":
                default:
                    field = "p.title";
                    break;
            }

            if (isAuthorSearch) {
                // 작성자 검색은 완전 일치
                whereSql.append(" AND ").append(field).append(" = ? ");
                paramList.add(keyword.trim());
            }
            else {
                whereSql.append(" and (");
                for (int i = 0; i < words.length; i++) {
                    if (i > 0) whereSql.append(" and ");
                    whereSql.append(field).append(" like ?");
                    paramList.add("%" + words[i] + "%");
                }
                whereSql.append(") ");
            }
        }

        String orderLimitSql = " order by p.createdAt desc, p.id DESC limit ? offset ?";
        paramList.add(pageSize);
        paramList.add(offset);

        String sql = baseSql + whereSql + orderLimitSql;

        try (QueryResult query = executeQuery(sql, paramList.toArray())) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory postCategory = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        postCategory = PostCategory.valueOf(categoryStr);
                    } catch (IllegalArgumentException e) {
                        postCategory = PostCategory.Normal;
                    }
                }

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), postCategory
                ));
            }
        }

        return list;
    }

    public List<BoardResponse> searchByKeywordRaw(String keyword, String type, String category, int offset, int limit) throws SQLException {
        List<BoardResponse> list = new ArrayList<>();

        String baseSql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId " +
                "from Posts p, users u where p.userId = u.id ";

        StringBuilder whereSql = new StringBuilder();
        List<Object> paramList = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            whereSql.append(" AND p.category = ? ");
            paramList.add(category);
        }

        if (keyword != null && !keyword.isBlank()) {
            String[] words = keyword.trim().split("\\s+");

            String field;
            boolean isAuthorSearch = false;
            switch (type) {
                case "content":
                    field = "p.content";
                    break;
                case "author":
                    field = "u.userName";
                    isAuthorSearch = true;
                    break;
                case "title":
                default:
                    field = "p.title";
                    break;
            }

            if (isAuthorSearch) {
                whereSql.append(" AND ").append(field).append(" = ? ");
                paramList.add(keyword.trim());
            } else {
                whereSql.append(" AND (");
                for (int i = 0; i < words.length; i++) {
                    if (i > 0) whereSql.append(" AND ");
                    whereSql.append(field).append(" LIKE ?");
                    paramList.add("%" + words[i] + "%");
                }
                whereSql.append(") ");
            }
        }

        String orderLimitSql = " ORDER BY p.createdAt DESC, p.id DESC LIMIT ? OFFSET ?";
        paramList.add(limit);
        paramList.add(offset);

        String sql = baseSql + whereSql + orderLimitSql;

        try (QueryResult query = executeQuery(sql, paramList.toArray())) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory postCategory = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        postCategory = PostCategory.valueOf(categoryStr);
                    } catch (IllegalArgumentException e) {
                        postCategory = PostCategory.Normal;
                    }
                }

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), postCategory
                ));
            }
        }

        return list;
    }

    public List<BoardResponse> findFixedNotices() throws SQLException {
        List<BoardResponse> list = new ArrayList<>();
        String sql = "select p.*, u.userName, (SELECT COUNT(*) FROM comments c WHERE c.postId = p.id) AS comment_count, p.id as postId " +
                " from Posts p, users u where p.userId=u.id AND p.category = 'Notice' ORDER BY p.createdAt DESC, p.id DESC LIMIT 3";

        try (QueryResult query = executeQuery(sql)) {
            var rs = query.Set;
            while (rs.next()) {
                LocalDateTime createdAt = rs.getString("createdAt") != null
                        ? LocalDateTime.parse(rs.getString("createdAt"))
                        : null;
                LocalDateTime updatedAt = rs.getString("updatedAt") != null
                        ? LocalDateTime.parse(rs.getString("updatedAt"))
                        : null;
                PostCategory postCategory = null;
                String categoryStr = rs.getString("category");
                if (categoryStr != null) {
                    try {
                        postCategory = PostCategory.valueOf(categoryStr);
                    } catch (IllegalArgumentException e) {
                        postCategory = PostCategory.Normal;
                    }
                }

                list.add(new BoardResponse(
                        rs.getInt("id"), rs.getString("userId"), createdAt, rs.getString("title"),
                        rs.getString("content"), rs.getInt("viewCount"), rs.getInt("recommendCount"),
                        updatedAt, rs.getString("userName"), rs.getInt("postId"), rs.getInt("comment_count"), postCategory
                ));
            }
        }
        return list;
    }

}
