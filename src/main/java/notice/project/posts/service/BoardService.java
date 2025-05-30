package notice.project.posts.service;

import notice.project.core.Transactional;
import notice.project.posts.DTO.BoardResponse;
import notice.project.posts.repository.BoardRepository;
import notice.project.exceptions.UserNotFoundException;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardService implements IBoardService {
    private final BoardRepository repo;

    public BoardService(BoardRepository repo) {
        this.repo = repo;
    }

    @Override
    @Transactional
    public List<BoardResponse> getPostList() throws SQLException, UserNotFoundException {

        return repo.findAll();
    }
}
