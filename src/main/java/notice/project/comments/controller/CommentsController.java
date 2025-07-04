package notice.project.comments.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.DTO.Token;
import notice.project.comments.DTO.CommentsResponse;
import notice.project.comments.service.CommentsService;
import notice.project.comments.service.ICommentsService;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@WebServlet("/write-comment")
public class CommentsController extends AuthBaseServlet {
    private ICommentsService commentsService;

    @Override
    public void init() throws ServletException {
        super.init();
        commentsService = ServiceFactory.createProxy(ICommentsService.class, CommentsService.class);
    }

    @Override
    @Authorization
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        try {

            String parentIdStr = request.getParameter("parentId");
            String refUserId = request.getParameter("refUserId");
            String content = request.getParameter("content");

            int postId = Integer.parseInt(request.getParameter("postId"));
            Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;

            var userId = ((Token)request.getSession(false).getAttribute("token")).getId();

            // 이거 어디에 쓰는거지?
            CommentsResponse resp = commentsService.upload(postId, parentId, refUserId, userId, content);

            String redirectUrl = "";
            if (request.getParameter("redirectUrl") != null) {
                redirectUrl = URLEncoder.encode(request.getParameter("redirectUrl"), StandardCharsets.UTF_8);
            }
            // 로그인 페이지로 넘어갈 수 있기 때문에, redirectUrl은 게시글 페이지가 담겨있다.
            response.sendRedirect(URLDecoder.decode(redirectUrl, StandardCharsets.UTF_8));
        }
        catch (IOException e) {
            // 예외 처리
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
