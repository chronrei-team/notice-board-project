package notice.project.example.service;

import notice.project.core.Transactional;
import notice.project.example.DTO.ExampleBoardResponse;
import notice.project.example.DTO.ExampleResponse;
import notice.project.example.repository.ExampleBoardRepository;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExampleBoardService implements IExampleBoardService{
    private final ExampleBoardRepository repo;

    public ExampleBoardService(ExampleBoardRepository repo) {
        this.repo = repo;
    }

    @Override
    @Transactional
    public List<ExampleBoardResponse> getPostList() throws SQLException, UserNotFoundException {
        // 비지니스 로직
        var posts = repo.findAll();
        List<ExampleBoardResponse> result = new ArrayList<>();
        for (var post : posts) {
            result.add(new ExampleBoardResponse(post.id, post.userId, post.createdAt, post.title, post.content, post.viewCount, post.recommendCount, post.userName));
        }
        return result;
    }
}
