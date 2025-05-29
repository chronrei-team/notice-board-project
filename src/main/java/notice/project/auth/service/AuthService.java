package notice.project.auth.service;

import notice.project.auth.DTO.LoginResponse;
import notice.project.auth.repository.UserRepository;
import notice.project.core.Transactional;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.UserNotFoundException;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Base64;
import java.util.UUID;

public class AuthService implements IAuthService {
    private final UserRepository userRepository;
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 1000; // 반복 횟수, 높을수록 안전하지만 느려짐
    private static final int KEY_LENGTH = 256;   // 결과 해시의 비트 길이
    private static final int SALT_LENGTH = 16;   // 솔트 바이트 길이 (128 bits)

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
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

    // 패스워드 검증
    private static boolean verifyPassword(String originalPassword, String storedPasswordAndSalt)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        String[] parts = storedPasswordAndSalt.split(":");
        if (parts.length != 2) {
            throw new IllegalArgumentException("저장된 패스워드 형식이 잘못되었습니다.");
        }
        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] hashFromStorage = Base64.getDecoder().decode(parts[1]);

        KeySpec spec = new PBEKeySpec(originalPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
        byte[] calculatedHash = factory.generateSecret(spec).getEncoded();

        // 생성된 해시와 저장된 해시를 비교
        return Arrays.equals(calculatedHash, hashFromStorage);
    }

    @Override
    @Transactional
    public LoginResponse verifyLogin(String userName, String password) throws SQLException, UserNotFoundException, InvalidPasswordException {
        var user = userRepository.findBy(userName);
        if (user == null) throw new UserNotFoundException();
        try {
            if (verifyPassword(password, user.passwordHash))
                throw new InvalidPasswordException();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new InvalidPasswordException();
        }

        user.lastLoginAt = LocalDateTime.now();
        userRepository.update(user);

        return new LoginResponse(userName);
    }

    @Override
    @Transactional
    public void register(String userName, String password) throws SQLException, AlreadyRegistedException {
        var user = userRepository.findBy(userName);
        if (user != null) throw new AlreadyRegistedException();
        try {
            user = new Users();
            user.id = UUID.randomUUID().toString();
            user.passwordHash = hashPassword(password);
            user.createdAt = LocalDateTime.now();
            user.lastLoginAt = null;
            user.updatedAt = null;
            user.deletedAt = null;
            user.status = UserStatus.Active;
            user.userName = userName;
            user.role = UserRole.User;

            userRepository.insert(user);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException(e);
        }
    }
}
