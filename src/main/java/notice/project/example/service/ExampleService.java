package notice.project.example.service;

import notice.project.core.Transactional;
import notice.project.example.DTO.ExamplePassword;
import notice.project.example.DTO.ExampleResponse;
import notice.project.example.repository.ExampleRepository;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;

public class ExampleService implements IExampleService {
    private final ExampleRepository repo;

    public ExampleService(ExampleRepository repo) {
        this.repo = repo;
    }

    @Override
    @Transactional
    public ExampleResponse getName(String userId) throws SQLException, UserNotFoundException {
        // 비지니스 로직
        var user = repo.findBy(userId);
        if (user == null) throw new UserNotFoundException();
        return new ExampleResponse(user.userName);
    }

    @Override
    @Transactional
    public ExamplePassword getPassword(String userId) throws SQLException, UserNotFoundException {
        // 비지니스 로직
        var user = repo.findBy(userId);
        if (user == null) throw new UserNotFoundException();
        return new ExamplePassword(user.passwordHash);
    }
}
