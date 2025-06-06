package notice.project.my.service;

import notice.project.auth.repository.UserRepository;
import notice.project.core.Transactional;
import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.InvalidUserNameException;
import notice.project.exceptions.UserNotFoundException;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class MyService implements IMyService {
    private final UserRepository userRepository;

    public MyService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public Users profileUpdate(String originalUserName, String newUserName, String originalPassword, String newPassword) throws InvalidUserNameException, SQLException, UserNotFoundException, NoSuchAlgorithmException, InvalidKeySpecException, AlreadyRegistedException, InvalidPasswordException {
        var user = userRepository.findBy(originalUserName);
        if (user == null) throw new UserNotFoundException();
        if (!user.verifyPassword(originalPassword)) throw new InvalidPasswordException();

        var change = false;

        if (!originalUserName.equals(newUserName)) {
            if (userRepository.findBy(newUserName) != null) throw new AlreadyRegistedException();
            user.initUserName(newUserName);
            change = true;
        }

        if ((newPassword != null && !newPassword.isEmpty())) {
            user.initPassword(newPassword);
            change = true;
        }

        if (change) {
            user.updatedAt = LocalDateTime.now();
            userRepository.update(user);
        }

        return user;
    }

    @Override
    @Transactional
    public void withdrawUser(String userName, String password) throws UserNotFoundException, InvalidPasswordException, SQLException, NoSuchAlgorithmException, InvalidKeySpecException {
        // 1. 사용자 조회
        var user = userRepository.findBy(userName);
        if (user == null) throw new UserNotFoundException();

        // 2. 비밀번호 검증
        if (!user.verifyPassword(password)) throw new InvalidPasswordException();

        // 3. 회원 탈퇴 처리
        userRepository.delete(user.id);
    }
}
