package notice.project.comments.service;

import notice.project.comments.DTO.CommentsResponse;

import java.sql.SQLException;

public interface ICommentsService {
    CommentsResponse upload(int postId, Integer parentCommentId, String referenceCommentUserId, String userId, String content) throws SQLException;
}
