package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.ServiceFactory;
import notice.project.posts.service.BoardService;
import notice.project.posts.service.IBoardService;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/board")
public class BoardController extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        try {
            var service = ServiceFactory.createProxy(
                    IBoardService.class,
                    BoardService.class
            );

            var resp = service.getPostList();

            request.setAttribute("posts", resp);
            request.getRequestDispatcher("/main_board.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        catch (UserNotFoundException e) {
            // 예외 처리
            throw new RuntimeException(e);
        }
    }
}
