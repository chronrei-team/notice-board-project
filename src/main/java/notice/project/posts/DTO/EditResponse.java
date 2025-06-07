package notice.project.posts.DTO;

import notice.project.entity.PostCategory;

import java.util.List;

public class EditResponse {
    private final String writerName;
    private final int postId;
    private final String title;
    private final String content;
    private final String category;
    private final List<Integer> fileIdList;
    private final List<String> fileNames;

    public EditResponse(String writerName, int postId, String title, String content, String category, List<Integer> fileIdList, List<String> fileNames) {
        this.writerName = writerName;
        this.postId = postId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.fileIdList = fileIdList;
        this.fileNames = fileNames;
    }

    public List<String> getFileNames() {
        return fileNames;
    }

    public List<Integer> getFileIdList() {
        return fileIdList;
    }

    public String getCategory() {
        return category;
    }

    public String getContent() {
        return content;
    }

    public String getTitle() {
        return title;
    }

    public int getPostId() {
        return postId;
    }

    public String getWriterName() {
        return writerName;
    }
}
