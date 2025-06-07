package notice.project.entity;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID; // User ID 타입

public class Posts {
    /** 게시글 ID (PK) */
    public Integer id;

    /** 작성자 유저 ID (FK, users.id 참조) */
    public String userId;

    /** 제목 */
    public String title;

    /** 본문 내용 */
    public String content;

    /** 작성 시간 */
    public LocalDateTime createdAt;

    /** 수정 시간 */
    public LocalDateTime updatedAt;

    /** 조회수 */
    public Integer viewCount = 0; // 기본값 설정

    /** 추천수 */
    public Integer recommendCount = 0; // 기본값 설정

    public PostCategory category;

    public Users user;
    public ArrayList<Comments> comments;
    public ArrayList<PostFiles> postFiles;


    public static boolean canWrite(UserRole role, PostCategory category) {
        return role == UserRole.Admin || category != PostCategory.Notice;
    }

    public boolean canEdit(UserRole role, String writerName) {
        return role == UserRole.Admin || (category != PostCategory.Notice && user.userName.equals(writerName));
    }

    public void fileUpload(List<Part> files, String rootPath, String uploadDirPath) {
        // 파일 데이터 받기 및 저장
        List<String> uploadedFileNames = new ArrayList<>(); // 업로드된 파일의 (서버 저장) 이름 목록
        List<String> originalFileNames = new ArrayList<>(); // 원본 파일 이름 목록
        List<Long> fileSize = new ArrayList<>();

        // 서버에 파일 저장할 경로 설정
        String uploadPath = rootPath + File.separator + uploadDirPath;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // 폴더 없으면 생성
        }

        for (Part file : files) {
            if (file != null && file.getSize() > 0) {
                String originalFileName = getSubmittedFileName(file); // 원본 파일 이름 추출
                if (originalFileName != null && !originalFileName.isEmpty()) {
                    // 파일 이름 중복 방지를 위해 UUID 추가 (선택적)
                    String extension = "";
                    int dotIndex = originalFileName.lastIndexOf('.');
                    if (dotIndex > 0) {
                        extension = originalFileName.substring(dotIndex);
                    }
                    String serverFileName = UUID.randomUUID().toString() + extension; // 서버에 저장될 파일 이름

                    // 파일 저장
                    try (InputStream input = file.getInputStream()) {
                        Files.copy(input, Paths.get(uploadPath, serverFileName), StandardCopyOption.REPLACE_EXISTING);
                        uploadedFileNames.add(serverFileName); // 서버 저장 파일 이름 추가
                        originalFileNames.add(originalFileName); // 원본 파일 이름 추가
                        fileSize.add(file.getSize()); // 파일 용량 추가
                        System.out.println("Uploaded file: " + originalFileName + " as " + serverFileName);
                    } catch (IOException e) {
                        System.err.println("File upload failed for " + originalFileName + ": " + e.getMessage());
                    }
                }
            }
        }

        for (int i = 0; i < uploadedFileNames.size(); i++) {
            var postFile = new PostFiles();
            postFile.uploadedAt = LocalDateTime.now();
            postFile.name = originalFileNames.get(i);
            postFile.url = uploadDirPath + "/" + uploadedFileNames.get(i);
            postFile.size = fileSize.get(i);

            postFiles.add(postFile);
        }
    }

    public void removeFile(ArrayList<Integer> postFileIdList, String rootPath, String uploadDirPath) {
        for (var file : postFiles) {
            if (postFileIdList.stream().noneMatch(postFileId -> postFileId.equals(file.id))) {
                file.remove(rootPath, uploadDirPath);
            }
        }
        postFiles.removeIf(file -> postFileIdList.stream().noneMatch(postFileId -> postFileId.equals(file.id)));
    }

    private static String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                // 일부 브라우저는 전체 경로를 포함할 수 있으므로 파일 이름만 추출
                return Paths.get(fileName).getFileName().toString();
            }
        }
        return null;
    }
}