package notice.project.my.DO;

public class UserResponse {
    private final String userName;
    private final String newUserName;
    private final String currentPassword;
    private final String newPassword;

    private final String failMessage;
    private final String successMessage;

    public UserResponse(String userName, String newUserName, String currentPassword, String newPassword, String failMessage, String successMessage) {
        this.userName = userName;
        this.newUserName = newUserName;
        this.currentPassword = currentPassword;
        this.newPassword = newPassword;
        this.failMessage = failMessage;
        this.successMessage = successMessage;
    }

    public String getNewUserName() {
        return newUserName;
    }

    public String getFailMessage() {
        return failMessage;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public String getCurrentPassword() {
        return currentPassword;
    }

    public String getSuccessMessage() {
        return successMessage;
    }

    public String getUserName() {
        return userName;
    }
}
