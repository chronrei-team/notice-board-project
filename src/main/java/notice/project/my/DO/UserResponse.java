package notice.project.my.DO;

public class UserResponse {
    private final String failMessage;
    private final String successMessage;

    public UserResponse(String failMessage, String successMessage) {
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
