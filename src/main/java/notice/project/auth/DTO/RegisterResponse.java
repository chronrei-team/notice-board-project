package notice.project.auth.DTO;

public class RegisterResponse {
    private final String failMessage;
    private final String successMessage;
    private final String userName;
    private final String password;


    public RegisterResponse(String failMessage, String successMessage, String userName, String password) {
        this.failMessage = failMessage;
        this.successMessage = successMessage;
        this.userName = userName;
        this.password = password;
    }

    public String getFailMessage() {
        return failMessage;
    }

    public String getSuccessMessage() {
        return successMessage;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassword() {
        return password;
    }
}
