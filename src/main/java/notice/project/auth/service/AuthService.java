package notice.project.auth.service;

import notice.project.auth.repository.UserRepository;
import notice.project.core.Transactional;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.Users;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.UUID;

public class AuthService implements IAuthService {
    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public Users verifyLogin(String userName, String password) throws SQLException {
        var user = userRepository.findBy(userName);
        if (user == null) throw new RuntimeException("유저가 존재하지 않습니다.");
        try {
            if (!user.verifyPassword(password))
                throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException();
        }

        user.lastLoginAt = LocalDateTime.now();
        userRepository.update(user);

        return user;
    }

    @Override
    @Transactional
    public void register(String userName, String password) throws SQLException {
        var user = userRepository.findBy(userName);
        if (user != null) throw new RuntimeException("이미 사용중인 닉네임 입니다.");
        try {
            user = new Users();
            user.id = UUID.randomUUID().toString();
            user.initPassword(password);
            user.createdAt = LocalDateTime.now();
            user.lastLoginAt = null;
            user.updatedAt = null;
            user.deletedAt = null;
            user.status = UserStatus.Active;
            user.initUserName(userName);
            user.role = UserRole.User;

            userRepository.insert(user);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException(e);
        }
    }
}
