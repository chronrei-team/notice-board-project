package notice.project.posts.DTO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

public class ViewResponse {
    private final int postId;
    private final String title;
    private final String authorName;
    private final LocalDateTime writtenAt;
    private final int viewCount;
    private final String content;
    private final boolean canEdit;
    private final List<File> files;
    private final List<Comment> comments;

    public ViewResponse(int postId, String title, String authorName, LocalDateTime writtenAt, int viewCount, String content,
                        boolean canEdit, List<File> files, List<Comment> comments) {
        this.postId = postId;
        this.title = title;
        this.authorName = authorName;
        this.writtenAt = writtenAt;
        this.viewCount = viewCount;
        this.content = content;
        this.canEdit = canEdit;
        this.files = files;
        this.comments = comments;
    }

    public boolean isCanEdit() {
        return canEdit;
    }

    public int getPostId() {
        return postId;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthorName() {
        return authorName;
    }

    public Date getWrittenAt() {
        return Date.from(writtenAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public String getContent() {
        return content;
    }

    public List<File> getFiles() {
        return files;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public int getViewCount() {
        return viewCount;
    }

}

