package notice.project.entity;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class Users {

    /** 사용자 고유 ID (PK) */
    public String id;

    /** 비밀번호 암호화 값 */
    public String passwordHash;

    /** 계정 생성 시간 */
    public LocalDateTime createdAt;

    /** 계정 정보 수정 시간 */
    public LocalDateTime updatedAt;

    /** 마지막 로그인 시간 */
    public LocalDateTime lastLoginAt;

    /** 탈퇴 시간 (nullable) */
    public LocalDateTime deletedAt;

    /** 계정 상태 (e.g., "ACTIVE", "INACTIVE") */
    public UserStatus status;

    /** 닉네임 (사용자 이름) */
    public String userName;

    /** 권한 (e.g., "USER", "ADMIN") */
    public UserRole role;

    public UserSuspend suspend;
    public ArrayList<Comments> comments;
    public ArrayList<Posts> posts;

    private static final String REGEX_HAS_WHITESPACE_OR_SPECIAL_CHAR = ".*\\s.*|.*[^a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s].*";
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 1000; // 반복 횟수, 높을수록 안전하지만 느려짐
    private static final int KEY_LENGTH = 256;   // 결과 해시의 비트 길이
    private static final int SALT_LENGTH = 16;   // 솔트 바이트 길이 (128 bits)

    public boolean isSuspended() {
        return status == UserStatus.Suspended && (suspend.suspendedEndAt == null || suspend.suspendedEndAt.isAfter(LocalDateTime.now()));
    }

    public String suspendMessage() {
        return "차단된 유저입니다.<br>"
                + "사유: "
                + (suspend.reason == null ? "" : suspend.reason)
                + "<br>기간: "
                + (suspend.suspendedEndAt == null ? "영구" : suspend.suspendedEndAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
    }

    public void initUserName(String userName) {
        if (userName == null) throw new RuntimeException("닉네임이 없습니다.");

        Pattern pattern = Pattern.compile(REGEX_HAS_WHITESPACE_OR_SPECIAL_CHAR);
        Matcher matcher = pattern.matcher(userName);
        if (matcher.matches()) throw new RuntimeException("닉네임은 특수문자 및 공백을 포함할 수 없습니다.");
        this.userName = userName;
    }

    // 새 패스워드 해시 생성
    private static String hashPassword(String password) throws NoSuchAlgorithmException, InvalidKeySpecException {
        SecureRandom random = SecureRandom.getInstanceStrong(); // 강력한 난수 생성기
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);

        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
        byte[] hash = factory.generateSecret(spec).getEncoded();

        // 솔트와 해시를 함께 저장 (예: Base64 인코딩 후 구분자로 연결)
        // 실제로는 DB에 salt 컬럼, hash 컬럼 따로 저장하는 것이 더 일반적입니다.
        // 여기서는 예시를 위해 하나의 문자열로 만듭니다.
        return Base64.getEncoder().encodeToString(salt) + ":" + Base64.getEncoder().encodeToString(hash);
    }

    public void initPassword(String password) throws NoSuchAlgorithmException, InvalidKeySpecException {
        passwordHash = hashPassword(password);
    }

    // 패스워드 검증
    public boolean verifyPassword(String inputPassword)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        String[] parts = passwordHash.split(":");
        if (parts.length != 2) {
            throw new IllegalArgumentException("저장된 패스워드 형식이 잘못되었습니다.");
        }
        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] hashFromStorage = Base64.getDecoder().decode(parts[1]);

        KeySpec spec = new PBEKeySpec(inputPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
        byte[] calculatedHash = factory.generateSecret(spec).getEncoded();

        // 생성된 해시와 저장된 해시를 비교
        return Arrays.equals(calculatedHash, hashFromStorage);
    }
}