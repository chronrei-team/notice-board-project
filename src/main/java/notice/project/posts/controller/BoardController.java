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
    private static final int PAGE_SIZE = 1; //테스트를 위해 1로 설정. 기본 10
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        try {
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
            var service = ServiceFactory.createProxy(
                    IBoardService.class,
                    BoardService.class
            );

            var resp = service.getPostList(page, PAGE_SIZE);
            int totalCount = service.getTotalCount();

            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            request.setAttribute("posts", resp);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
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
