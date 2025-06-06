package notice.project.auth.DTO;

import notice.project.entity.UserRole;

public class Token {
    private final String userName;
    private final UserRole role;

    public Token(String userName, UserRole role) {
        this.userName = userName;
        this.role = role;
    }

    public UserRole getRole() {
        return role;
    }

    public String getUserName() {
        return userName;
    }
}
