package notice.project.entity;

public enum PostCategory {
    Normal("자유"),
    Qna("질문"),
    Information("정보"),
    Notice("공지");

    private final String displayName;

    PostCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
