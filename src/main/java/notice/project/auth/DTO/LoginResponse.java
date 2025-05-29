package notice.project.auth.DTO;

public class LoginResponse {
    private final String message;
    public LoginResponse(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return message;
    }
}
