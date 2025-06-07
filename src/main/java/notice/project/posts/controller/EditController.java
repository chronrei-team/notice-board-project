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
import notice.project.posts.service.EditService;
import notice.project.posts.service.IEditService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/board/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10,  // 10 MB (이 크기까지는 메모리에 보관, 넘으면 디스크 임시 파일 사용)
        maxFileSize = 1024 * 1024 * 20, // 개별 파일 최대 10 MB
        maxRequestSize = 1024 * 1024 * 60 // 전체 요청 최대 50 MB
)
public class EditController extends AuthBaseServlet {
    private IEditService editService;

    @Override
    public void init() throws ServletException {
        super.init();
        editService = ServiceFactory.createProxy(IEditService.class, EditService.class);
    }

    @Authorization
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var token = (Token)request.getSession(false).getAttribute("token");
        var role = token.getRole();
        var writerName = token.getUserName();
        var postId = Integer.parseInt(request.getParameter("postId"));

        try {
            var editResponse = editService.getEditContent(postId, writerName, role);
            request.setAttribute("EditResponse", editResponse);

            if (role == UserRole.Admin) request.setAttribute("admin", true);
            request.getRequestDispatcher("/write.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Authorization
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var token = (Token)request.getSession(false).getAttribute("token");
        var postId = Integer.parseInt(request.getParameter("postId"));

        String title = request.getParameter("title"); // 일반 텍스트 필드는 getParameter로도 가능
        String category = request.getParameter("category");
        String content = request.getParameter("content"); // TOAST UI Editor 내용

        ArrayList<Part> files = new ArrayList<>();
        files.add(request.getPart("file1"));
        files.add(request.getPart("file2"));
        files.add(request.getPart("file3"));


        try {
            ArrayList<Integer> fileBeforeIdList = new ArrayList<>();
            if (request.getParameter("file1_before_id") != null && !request.getParameter("file1_before_id").isEmpty())
                fileBeforeIdList.add(Integer.parseInt(request.getParameter("file1_before_id")));
            if (request.getParameter("file2_before_id") != null && !request.getParameter("file2_before_id").isEmpty())
                fileBeforeIdList.add(Integer.parseInt(request.getParameter("file2_before_id")));
            if (request.getParameter("file3_before_id") != null && !request.getParameter("file3_before_id").isEmpty())
                fileBeforeIdList.add(Integer.parseInt(request.getParameter("file3_before_id")));

            if (title.isEmpty() || category.isEmpty() || content.isEmpty()) {
                throw new RuntimeException("파라미터가 유효하지 않습니다.");
            }

            editService.editPost(postId, token, title, fileBeforeIdList, PostCategory.valueOf(category), content, files,
                    getServletContext().getRealPath(""), getServletContext().getInitParameter("upload_dir"));

            response.sendRedirect(request.getContextPath() + "/board/view?postId=" + postId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
