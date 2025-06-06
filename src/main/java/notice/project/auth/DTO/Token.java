package notice.project.auth.DTO;

import notice.project.entity.UserRole;

public class Token {
    private final String id;
    private final String userName;
    private final UserRole role;

    public Token(String id, String userName, UserRole role) {
        this.id = id;
        this.userName = userName;
        this.role = role;
    }

    public UserRole getRole() {
        return role;
    }

    public String getUserName() {
        return userName;
    }

    public String getId() {
        return id;
    }
}
