package notice.project.auth.service;

import notice.project.auth.repository.UserRepository;
import notice.project.core.Transactional;
import notice.project.entity.UserRole;
import notice.project.entity.UserStatus;
import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.InvalidUserNameException;
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

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public Users verifyLogin(String userName, String password) throws SQLException, UserNotFoundException, InvalidPasswordException {
        var user = userRepository.findBy(userName);
        if (user == null) throw new UserNotFoundException();
        try {
            if (!user.verifyPassword(password))
                throw new InvalidPasswordException();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new InvalidPasswordException();
        }

        user.lastLoginAt = LocalDateTime.now();
        userRepository.update(user);

        return user;
    }

    @Override
    @Transactional
    public void register(String userName, String password) throws SQLException, AlreadyRegistedException, InvalidUserNameException {
        var user = userRepository.findBy(userName);
        if (user != null) throw new AlreadyRegistedException();
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
