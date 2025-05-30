package notice.project.posts.DTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class BoardResponse {
    private final Integer id;
    private final String userId;
    private final LocalDateTime createdAt;
    private final String title;
    private final String content;
    private final Integer viewCount;
    private final Integer recommendCount;
    private final LocalDateTime updatedAt;
    private final String userName;
    private final Integer postId;
    private final Integer commentCount;

    public BoardResponse(Integer id, String userId, LocalDateTime createdAt, String title, String content, Integer viewCount, Integer recommendCount, LocalDateTime updatedAt, String userName, Integer postId, Integer commentCount) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.title = title;
        this.content = content;
        this.viewCount = viewCount;
        this.recommendCount = recommendCount;
        this.updatedAt = updatedAt;
        this.userName = userName;
        this.postId = postId;
        this.commentCount = commentCount;
    }

    public Integer getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public Integer getRecommendCount() {
        return recommendCount;
    }

    public String getUserName() {
        return userName;
    }

    public Integer getPostId() { return postId; }

    public Integer getCommentCount() { return commentCount; }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return createdAt.format(formatter);
    }
}
