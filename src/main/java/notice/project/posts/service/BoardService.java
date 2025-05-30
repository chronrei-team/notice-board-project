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
    public List<BoardResponse> getPostList(int page, int pageSize) throws SQLException, UserNotFoundException {

        return repo.findAll(page, pageSize);
    }

    @Override
    @Transactional
    public int getTotalCount() throws SQLException {
        return repo.countAll();
    }
}
