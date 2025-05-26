package notice.project.entity;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.UUID;


import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

public class Users {

    /** 사용자 고유 ID (PK) */
    public String id;

    /** 비밀번호 암호화 값 */
    public String passwordHash;

    /** 계정 생성 시간 */
    public LocalDateTime createdAt;

    /** 계정 정보 수정 시간 */
    public LocalDateTime updatedAt;

    /** 마지막 로그인 시간 */
    public LocalDateTime lastLoginAt;

    /** 탈퇴 시간 (nullable) */
    public LocalDateTime deletedAt;

    /** 계정 상태 (e.g., "ACTIVE", "INACTIVE", "DELETED") */
    public String status;

    /** 닉네임 (사용자 이름) */
    public String userName;

    /** 권한 (e.g., "USER", "ADMIN") */
    public String role;

    public ArrayList<Comments> comments;
    public ArrayList<Posts> posts;

    // 모든 필드를 받는 생성자
    public Users(String id, String passwordHash, LocalDateTime createdAt, LocalDateTime updatedAt,
                LocalDateTime lastLoginAt, LocalDateTime deletedAt, String status, String userName, String role
            , ArrayList<Comments> comments, ArrayList<Posts> posts) {
        this.id = id;
        this.passwordHash = passwordHash;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lastLoginAt = lastLoginAt;
        this.deletedAt = deletedAt;
        this.status = status;
        this.userName = userName;
        this.role = role;
        this.comments = comments;
        this.posts = posts;
    }
}