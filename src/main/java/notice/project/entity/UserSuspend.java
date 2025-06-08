package notice.project.entity;

import java.time.LocalDateTime;

public class UserSuspend {
    public String id; // PK, FK
    public LocalDateTime suspendedAt;
    public LocalDateTime suspendedEndAt;
    public String reason;

    public Users user;
}
