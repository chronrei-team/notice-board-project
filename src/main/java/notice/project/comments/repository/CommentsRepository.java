package notice.project.comments.repository;

import notice.project.core.BaseRepository;
import notice.project.core.QueryResult;
import notice.project.entity.Comments;
import notice.project.comments.DTO.CommentsResponse;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CommentsRepository extends BaseRepository {
    public int upload(Comments comment) throws SQLException {
        return executeCommandReturnKey("INSERT INTO comments (postId, parentCommentId, referenceCommentUserId, userId, content, createdAt) " +
                        " VALUES (?, ?, ?, ?, ?, ?)",
                comment.postId, comment.parentCommentId, comment.referenceCommentUserId,
                comment.userId, comment.content, comment.createdAt
        );
    }
}
