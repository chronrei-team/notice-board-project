package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import notice.project.auth.DTO.Token;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;
import notice.project.entity.PostCategory;
import notice.project.entity.UserRole;
import notice.project.entity.Users;
import notice.project.exceptions.UnauthorizedException;
import notice.project.posts.service.IUploadService;
import notice.project.posts.service.UploadService;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@WebServlet("/board/write")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10,  // 10 MB (이 크기까지는 메모리에 보관, 넘으면 디스크 임시 파일 사용)
        maxFileSize = 1024 * 1024 * 20, // 개별 파일 최대 10 MB
        maxRequestSize = 1024 * 1024 * 60 // 전체 요청 최대 50 MB
)
public class WriteController extends AuthBaseServlet {
    private IUploadService uploadService;

    @Override
    public void init() throws ServletException {
        super.init();
        uploadService = ServiceFactory.createProxy(IUploadService.class, UploadService.class);
    }

    @Authorization
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var role = ((Token)request.getSession(false).getAttribute("token")).getRole();
        if (role == UserRole.Admin) request.setAttribute("admin", true);
        request.getRequestDispatcher("/write.jsp").forward(request, response);
    }

    @Authorization
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 한글 깨짐 방지
        var upload = getServletContext().getInitParameter("upload_dir");

        // 1. 텍스트 데이터 받기
        String title = request.getParameter("title"); // 일반 텍스트 필드는 getParameter로도 가능
        String category = request.getParameter("category");
        String content = request.getParameter("content"); // TOAST UI Editor 내용

        System.out.println("Title: " + title);
        System.out.println("Category: " + category);
        System.out.println("Content (Markdown/HTML): " + content);

        ArrayList<Part> files = new ArrayList<>();
        files.add(request.getPart("file1"));
        files.add(request.getPart("file2"));
        files.add(request.getPart("file3"));

        try {
            if (title == null || title.isEmpty() || category == null || category.isEmpty() || content == null || content.isEmpty()) {
                throw new RuntimeException();
            }

            var uploadDir = getServletContext().getInitParameter("upload_dir");
            uploadService.uploadPost((Users)request.getSession(false).getAttribute("token"),
                    title, PostCategory.valueOf(category), content, files, getServletContext().getRealPath(""), uploadDir);
        }
        catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/");
        } catch (UnauthorizedException e) {
            // 정상적인 방법으로는 올 수 없다.
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
