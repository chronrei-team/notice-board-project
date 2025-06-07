package notice.project.posts.service;

import jakarta.servlet.http.Part;
import notice.project.auth.DTO.Token;
import notice.project.core.Transactional;
import notice.project.entity.*;
import notice.project.posts.repository.BoardRepository;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UploadService implements IUploadService {
    private final BoardRepository boardRepository;

    public UploadService(BoardRepository boardRepository) {
        this.boardRepository = boardRepository;
    }


    @Override
    public String uploadImage(Part image, String rootPath, String uploadDirPath) throws IOException {
        String fileName = Paths.get(image.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = fileName.substring(dotIndex);
        }
        fileName = UUID.randomUUID().toString() + extension;

        // 서버에 저장할 경로
        String uploadPath = rootPath + File.separator + uploadDirPath;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 저장
        String filePath = uploadPath + File.separator + fileName;
        image.write(filePath);

        return fileName;
    }

    @Override
    @Transactional
    public int uploadPost(Token user, String title, PostCategory category, String content,
                          List<Part> files, String rootPath, String uploadDirPath) throws SQLException {

        if (!Posts.canWrite(user.getRole(), category)) {
            throw new RuntimeException("권한이 없습니다.");
        }

        Posts post = new Posts();
        post.title = title;
        post.category = category;
        post.content = content;
        post.userId = user.getId();
        post.createdAt = LocalDateTime.now();
        post.fileUpload(files, rootPath, uploadDirPath);

        return boardRepository.upload(post);
    }
}
