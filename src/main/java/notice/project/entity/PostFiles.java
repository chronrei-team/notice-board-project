package notice.project.entity;

import java.time.LocalDateTime;
import java.util.Objects;

public class PostFiles {

    /** 첨부파일 ID (PK) */
    public Integer id;

    /** 게시글 ID (FK, posts.id 참조) */
    public Integer postId;

    /** 원본 파일 이름 */
    public String name;

    /** 파일 저장 위치/URL */
    public String url;

    /** 파일 용량 */
    public long size;

    /** 업로드 시간 */
    public LocalDateTime uploadedAt;

    public Posts post;

}