package notice.project.comments.DTO;

import java.time.LocalDateTime;

public class CommentsResponse {
    private final Integer id;
    private final Integer postId;
    private final Integer parentCommentId;
    private final String referenceCommentUserId;
    private final String userId;
    private final String content;
    private final LocalDateTime createdAt;

    public CommentsResponse(Integer id, Integer postId, Integer parentCommentId, String referenceCommentUserId,
                            String userId, String content, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.content = content;
        this.postId = postId;
        this.parentCommentId = parentCommentId;
        this.referenceCommentUserId = referenceCommentUserId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Integer getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public String getContent() {
        return content;
    }

    public Integer getPostId() {
        return postId;
    }

    public Integer getParentCommentId() {
        return parentCommentId;
    }

    public String getReferenceCommentUserId() {
        return referenceCommentUserId;
    }
}
