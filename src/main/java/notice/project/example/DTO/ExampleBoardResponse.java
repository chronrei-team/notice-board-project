package notice.project.example.DTO;

import java.time.LocalDateTime;

public class ExampleBoardResponse {
    private final Integer id;
    private final String userId;
    private final LocalDateTime createdAt;
    private final String title;
    private final String content;
    private final Integer viewCount;
    private final Integer recommendCount;

    public ExampleBoardResponse(Integer id, String userId, LocalDateTime createdAt, String title, String content, Integer viewCount, Integer recommendCount) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.title = title;
        this.content = content;
        this.viewCount = viewCount;
        this.recommendCount = recommendCount;
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
}
