package notice.project.posts.DTO;

import notice.project.entity.PostCategory;

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
    private final PostCategory postCategory;
    private String highlightedTitle;
    private String highlightedUserName;

    public BoardResponse(Integer id, String userId, LocalDateTime createdAt, String title, String content, Integer viewCount,
                         Integer recommendCount, LocalDateTime updatedAt, String userName, Integer postId, Integer commentCount, PostCategory postCategory) {
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
        this.postCategory = postCategory;
    }

    public Integer getId() { return id; }

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

    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public PostCategory getPostCategory() { return postCategory; }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return createdAt.format(formatter);
    }

    public String getHighlightedTitle() {
        return highlightedTitle;
    }

    public void setHighlightedTitle(String highlightedTitle) {
        this.highlightedTitle = highlightedTitle;
    }

    public String getHighlightedUserName() {
        return highlightedUserName;
    }

    public void setHighlightedUserName(String highlightedUserName) {
        this.highlightedUserName = highlightedUserName;
    }
}
