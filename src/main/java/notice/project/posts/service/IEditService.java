package notice.project.posts.service;

import jakarta.servlet.http.Part;
import notice.project.auth.DTO.Token;
import notice.project.entity.PostCategory;
import notice.project.entity.UserRole;
import notice.project.posts.DTO.EditResponse;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public interface IEditService {
    EditResponse getEditContent(int postId, String writerName, UserRole role) throws SQLException;
    void editPost(int postId, Token user, String title, ArrayList<Integer> fileIdList, PostCategory category, String content,
             List<Part> files, String rootPath, String uploadDirPath) throws SQLException;
}
