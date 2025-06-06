package notice.project.posts.DTO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

public class Comment {
    private final int id;
    private final String authorId;
    private final String authorName;
    private final String content;
    private final LocalDateTime writtenAt;
    private final String referenceUserName;
    private final List<Comment> children;

    public Comment(int id, String authorId, String authorName, String content, LocalDateTime writtenAt, String referenceUserName, List<Comment> children) {
        this.id = id;
        this.authorId = authorId;
        this.authorName = authorName;
        this.content = content;
        this.writtenAt = writtenAt;
        this.referenceUserName = referenceUserName;
        this.children = children;
    }

    public String getAuthorName() {
        return authorName;
    }

    public String getContent() {
        return content;
    }

    public Date getWrittenAt() {
        return Date.from(writtenAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public String getReferenceUserName() {
        return referenceUserName;
    }

    public List<Comment> getChildren() {
        return children;
    }

    public String getAuthorId() {
        return authorId;
    }

    public int getId() {
        return id;
    }
}
