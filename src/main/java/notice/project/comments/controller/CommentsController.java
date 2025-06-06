package notice.project.comments.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.comments.DTO.CommentsResponse;
import notice.project.comments.service.CommentsService;
import notice.project.comments.service.ICommentsService;
import notice.project.core.ServiceFactory;
import notice.project.example.service.ExampleService;
import notice.project.example.service.IExampleService;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/write-comment")
public class CommentsController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        try {

            String parentIdStr = request.getParameter("parentId");
            String refUserId = request.getParameter("refUserId");
            String content = request.getParameter("content");

            int postId = Integer.parseInt(request.getParameter("postId"));
            Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;


            String userId = (String) request.getAttribute("userId");
            if (userId == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
                return;
            }

            var service = ServiceFactory.createProxy(
                    ICommentsService.class,
                    CommentsService.class
            );

            CommentsResponse resp = service.upload(postId, parentId, refUserId, userId, content);

            request.getSession().setAttribute("message", "댓글이 입력되었습니다.");

            // 상세 페이지로 리다이렉트 (나중에 페이지 구현되면 URL 수정)
            response.sendRedirect("/post-detail?postId=" + postId);
        }
        catch (IOException e) {
            // 예외 처리
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
