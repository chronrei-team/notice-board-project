package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.DTO.Token;
import notice.project.core.ServiceFactory;
import notice.project.posts.service.BoardService;
import notice.project.posts.service.IBoardService;

import java.io.IOException;

@WebServlet("/board/view")
public class ViewController extends HttpServlet {
    private IBoardService boardService;

    @Override
    public void init() throws ServletException {
        super.init();
        boardService = ServiceFactory.createProxy(IBoardService.class, BoardService.class);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var postId = request.getParameter("postId");
        var session = request.getSession(false);
        var token = session != null ? (Token)session.getAttribute("token") : null;

        try {
            if (postId == null) {
                throw new Exception();
            }

            var viewResponse = boardService.getPostDetail(Integer.parseInt(postId), token);

            request.setAttribute("ViewResponse", viewResponse);
            request.getRequestDispatcher("/view.jsp").forward(request, response);
        }
        catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }
}
