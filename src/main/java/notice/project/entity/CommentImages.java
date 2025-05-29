package notice.project.entity;

import java.time.LocalDateTime;
import java.util.Objects;

public class CommentImages {

    /** 댓글 이미지 ID (PK) */
    public Integer id;

    /** 댓글 ID (FK, comments.id 참조) */
    public Integer commentId;

    /** 원본 파일 이름 */
    public String name;

    /** 이미지 저장 경로/URL */
    public String url;

    /** 업로드 시간 */
    public LocalDateTime uploadedAt;

    public Comments comment;
}