package notice.project.posts.service;

import jakarta.servlet.http.Part;
import notice.project.auth.DTO.Token;
import notice.project.core.Transactional;
import notice.project.entity.PostCategory;
import notice.project.entity.Posts;
import notice.project.entity.UserRole;
import notice.project.posts.DTO.EditResponse;
import notice.project.posts.repository.BoardRepository;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class EditService implements IEditService {
    private final BoardRepository boardRepository;

    public EditService(BoardRepository boardRepository) {
        this.boardRepository = boardRepository;
    }

    @Override
    @Transactional
    public EditResponse getEditContent(int postId, String writerName, UserRole role) throws SQLException {
        var post = boardRepository.findPost(postId);

        if (post == null) throw new RuntimeException("게시글을 찾을 수 없습니다.");
        if (!post.canEdit(role, writerName)) throw new RuntimeException("권한이 없습니다.");

        return new EditResponse(
                writerName,
                postId,
                post.title,
                post.content,
                post.category.name(),
                post.postFiles.stream().map(f -> f.id).toList(),
                post.postFiles.stream().map(f -> f.name).toList()
        );
    }

    @Override
    @Transactional
    public void editPost(int postId, Token user, String title, ArrayList<Integer> fileIdList, PostCategory category, String content,
                         List<Part> files, String rootPath, String uploadDirPath) throws SQLException {

        var post = boardRepository.findPost(postId);

        if (post == null) throw new RuntimeException("게시글을 찾을 수 없습니다.");
        if (!post.canEdit(user.getRole(), user.getUserName())) throw new RuntimeException("권한이 없습니다.");
        if (!Posts.canWrite(user.getRole(), category)) throw new RuntimeException("권한이 없습니다.");

        post.title = title;
        post.category = category;
        post.content = content;
        post.userId = user.getId();
        post.updatedAt = LocalDateTime.now();
        post.removeFile(fileIdList, rootPath, uploadDirPath);
        post.fileUpload(files, rootPath, uploadDirPath);

        boardRepository.save(post);
    }
}
