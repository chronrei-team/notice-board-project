package notice.project.posts.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.*;
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

    public int upload(Posts post) throws SQLException {
        int pk = executeCommandReturnKey("INSERT INTO posts(userId, title, content, createdAt, category) " +
                "VALUES(?, ?, ?, ?, ?)",
                post.userId, post.title, post.content, post.createdAt, post.category);

        for (var postFile : post.postFiles) {
            postFile.postId = pk;
            executeCommand("INSERT INTO post_files(postId, name, url, uploadedAt) " +
                    "VALUES(?, ?, ?, ?)",
                    postFile.postId, postFile.name, postFile.url, postFile.uploadedAt);
        }

        return pk;
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
        // 'Notice' 하드코딩을 카테코리로 변경해야함.
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

    public Posts findPost(int postId) throws SQLException {
        Posts post;
        try (QueryResult query = executeQuery("SELECT p.id, p.userId, p.title, p.content, p.createdAt, p.viewCount, p.recommendCount, p.category, " +
                "u.userName AS post_writer_name " +
                "FROM posts p " +
                "JOIN users u ON p.userId = u.id " +
                "where p.id = ?", postId)) {
            var rs = query.Set;
            if (rs.next()) {
                post = new Posts();
                post.id = rs.getInt("id");
                post.userId = rs.getString("userId");
                post.title = rs.getString("title");
                post.content = rs.getString("content");
                post.createdAt = LocalDateTime.parse(rs.getString("createdAt"));
                post.viewCount = rs.getInt("viewCount");
                post.recommendCount = rs.getInt("recommendCount");
                post.category = PostCategory.valueOf(rs.getString("category"));
                post.user = new Users();
                post.user.userName = rs.getString("post_writer_name");
                post.postFiles = new ArrayList<>();
                post.comments = new ArrayList<>();
            }
            else
                return null;
        }

        try (var query = executeQuery("SELECT pf.name AS file_name, pf.url AS file_url, pf.size AS file_size " +
                "FROM post_files pf " +
                "JOIN posts p ON pf.postId = p.id " +
                "WHERE pf.postId = ?", postId)) {
            var rs = query.Set;
            while (rs.next()) {
                var file = new PostFiles();
                file.postId = postId;
                file.url = rs.getString("file_url");
                file.name = rs.getString("file_name");
                file.size = rs.getLong("file_size");
                post.postFiles.add(file);
            }
        }

        try (var query = executeQuery("SELECT c.id AS c_id, c.userId AS c_user_id, " +
                "c.parentCommentId AS c_parent_id, c.referenceCommentUserId AS c_reference_user_id, " +
                "c.content AS c_content, c.createdAt AS c_writtenAt, " +
                "cu.userName AS c_writer_name, " +
                "(SELECT ru.userName " +
                "   FROM comments rc " +
                "   JOIN users ru ON rc.userId = ru.id " +
                "   WHERE rc.id = c.parentCommentId) AS rc_writer_name " +
                "FROM comments c " +
                "JOIN users cu ON cu.id = c.userId " +
                "WHERE c.postId = ?", postId)) {
            var rs = query.Set;
            while (rs.next()) {
                var comment = new Comments();
                comment.id = rs.getInt("c_id");
                comment.userId = rs.getString("c_user_id");
                comment.parentCommentId = rs.getInt("c_parent_id");
                comment.referenceCommentUserId = rs.getString("c_reference_user_id");
                comment.content = rs.getString("c_content");
                comment.createdAt = LocalDateTime.parse(rs.getString("c_writtenAt"));
                comment.writer = new Users();
                comment.writer.userName = rs.getString("c_writer_name");
                comment.referenceComment = new Comments();
                comment.referenceComment.userId = rs.getString("c_reference_user_id");
                comment.referenceComment.writer = new Users();
                comment.referenceComment.writer.userName = rs.getString("rc_writer_name");

                post.comments.add(comment);
            }
        }

        return post;
    }
}
