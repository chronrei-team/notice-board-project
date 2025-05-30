package notice.project.auth.DTO;

public class LoginResponse {
    private final String message;
    private final String userName;
    private final String password;

    public LoginResponse(String message, String userName, String password) {
        this.message = message;
        this.userName = userName;
        this.password = password;
    }


    public String getMessage() {
        return message;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassword() {
        return password;
    }
}
