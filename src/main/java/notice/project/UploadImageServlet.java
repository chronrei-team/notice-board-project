package com.wplab.noticeboardproject.noticeboardproject;

import java.io.*;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/uploadImage")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1MB
        maxFileSize = 1024 * 1024 * 5,      // 5MB
        maxRequestSize = 1024 * 1024 * 10   // 10MB
)
public class UploadImageServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads"; // webapp/uploads/

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json; charset=UTF-8");

        Part filePart = request.getPart("image"); // "image"는 JS에서 formData에 append한 키와 같아야 함
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // 서버에 저장할 경로
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 저장
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // 클라이언트가 접근 가능한 URL 경로
        String fileUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;

        // 응답 JSON
        response.getWriter().write("{\"url\": \"" + fileUrl + "\"}");
    }
}
