package notice.project.comments.service;

import notice.project.comments.DTO.CommentsResponse;
import notice.project.comments.repository.CommentsRepository;
import notice.project.core.Transactional;
import notice.project.entity.Comments;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class CommentsService implements ICommentsService {
    private final CommentsRepository commentsRepository;

    public CommentsService() {
        this.commentsRepository = new CommentsRepository();
    }

    @Override
    @Transactional
    public CommentsResponse upload(int postId, Integer parentCommentId, String referenceCommentUserId, String userId, String content) throws SQLException {
        LocalDateTime now = LocalDateTime.now();

        Comments comment = new Comments();
        comment.id = null;
        comment.postId = postId;
        comment.parentCommentId = parentCommentId;
        comment.referenceCommentUserId = referenceCommentUserId;
        comment.userId = userId;
        comment.content = content;
        comment.createdAt = now;

        int generatedId = commentsRepository.upload(comment);

        return new CommentsResponse(
                generatedId,
                postId,
                parentCommentId,
                referenceCommentUserId,
                userId,
                content,
                now
        );
    }
}
