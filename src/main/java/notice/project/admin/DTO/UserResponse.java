package notice.project.admin.DTO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class UserResponse {
    private final String userId;
    private final String username;
    private final String status;
    private final LocalDateTime joinDate;
    private final LocalDateTime suspensionEndDate;

    public UserResponse(String userId, String userName, String status, LocalDateTime joinDate, LocalDateTime suspensionEndDate) {
        this.userId = userId;
        this.username = userName;
        this.status = status;
        this.joinDate = joinDate;
        this.suspensionEndDate = suspensionEndDate;
    }

    public String getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getStatus() {
        return status;
    }

    public Date getJoinDate() {
        return Date.from(joinDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getSuspensionEndDate() {
        if (suspensionEndDate == null) return null;
        return Date.from(suspensionEndDate.atZone(ZoneId.systemDefault()).toInstant());

    }
}
