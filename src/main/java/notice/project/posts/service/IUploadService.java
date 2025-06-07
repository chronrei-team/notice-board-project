package notice.project.posts.service;

import jakarta.servlet.http.Part;
import notice.project.auth.DTO.Token;
import notice.project.entity.PostCategory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public interface IUploadService {
    String uploadImage(Part image, String realPath, String uploadDirPath) throws IOException;
    int uploadPost(Token user, String title, PostCategory category, String content,
                   List<Part> files, String rootPath, String uploadDirPath) throws SQLException;
}
