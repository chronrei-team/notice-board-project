package notice.project.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Objects;
import java.util.UUID; // User ID 타입

public class Posts {

    /** 게시글 ID (PK) */
    public Integer id;

    /** 작성자 유저 ID (FK, users.id 참조) */
    public String userId;

    /** 유저 ID를 이름으로 바꾸기 위한 용도 */
    public String userName;

    /** 제목 */
    public String title;

    /** 본문 내용 */
    public String content;

    /** 작성 시간 */
    public LocalDateTime createdAt;

    /** 수정 시간 */
    public LocalDateTime updatedAt;

    /** 조회수 */
    public Integer viewCount = 0; // 기본값 설정

    /** 추천수 */
    public Integer recommendCount = 0; // 기본값 설정

    public Users user;
    public ArrayList<Comments> comments;
    public ArrayList<PostFiles> postFiles;

}