package notice.project.auth.DTO;

public class RegisterResponse {
    private final String failMessage;
    private final String successMessage;


    public RegisterResponse(String failMessage, String successMessage) {
        this.failMessage = failMessage;
        this.successMessage = successMessage;
    }

    public String getFailMessage() {
        return failMessage;
    }

    public String getSuccessMessage() {
        return successMessage;
    }
}
