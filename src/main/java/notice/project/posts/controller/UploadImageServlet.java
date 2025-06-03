package notice.project.posts.controller;

import java.io.*;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;
import notice.project.posts.service.IUploadService;
import notice.project.posts.service.UploadService;

@WebServlet("/uploadImage")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1MB
        maxFileSize = 1024 * 1024 * 20,      // 20MB
        maxRequestSize = 1024 * 1024 * 60   // 60MB
)
public class UploadImageServlet extends AuthBaseServlet {
    private IUploadService uploadService;

    @Override
    public void init() throws ServletException {
        super.init();
        uploadService = ServiceFactory.createProxy(IUploadService.class, UploadService.class);
    }

    @Override
    @Authorization
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json; charset=UTF-8");

        Part filePart = request.getPart("image"); // "image"는 JS에서 formData에 append한 키와 같아야 함
        var uploadDir = getServletContext().getInitParameter("upload_dir");
        var fileName = uploadService.uploadImage(filePart, getServletContext().getRealPath(""), uploadDir);

        // 클라이언트가 접근 가능한 URL 경로
        String fileUrl = request.getContextPath() + "/" + uploadDir + "/" + fileName;

        // 응답 JSON
        response.getWriter().write("{\"url\": \"" + fileUrl + "\"}");
    }
}
