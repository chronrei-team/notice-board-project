package notice.project.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Objects;
import java.util.UUID; // User ID 타입

public class Comments {

    /** 댓글 ID (PK) */
    public Integer id;

    /** 게시글 ID (FK, posts.id 참조) */
    public Integer postId;

    /** 부모 댓글 ID (FK, comments.id 참조, 대댓글이 아닐 경우 null) */
    public Integer parentCommentId;

    /** 참조 댓글 작성자 ID (String 타입, ERD 명세 따름) */
    public String referenceCommentUserId; // users.id (UUID)를 문자열로 저장하는 것으로 가정

    /** 댓글 작성자 ID (FK, users.id 참조) */
    public String userId;

    /** 댓글 내용 */
    public String content;

    /** 작성 시간 */
    public LocalDateTime createdAt;

    public Users writer;
    public Posts post;
    public ArrayList<Comments> subComments;
    public ArrayList<CommentImages> images;

    // 모든 필드를 받는 생성자
    public Comments(Integer id, Integer postId, Integer parentCommentId, String referenceCommentUserId,
                   String userId, String content, LocalDateTime createdAt,
                    Users writer, Posts post, ArrayList<Comments> subComments, ArrayList<CommentImages> images) {
        this.id = id;
        this.postId = postId;
        this.parentCommentId = parentCommentId;
        this.referenceCommentUserId = referenceCommentUserId;
        this.userId = userId;
        this.content = content;
        this.createdAt = createdAt;
        this.writer = writer;
        this.post = post;
        this.subComments = subComments;
        this.images = images;
    }
}