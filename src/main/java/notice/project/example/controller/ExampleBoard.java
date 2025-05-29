package notice.project.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.ServiceFactory;
import notice.project.example.service.ExampleBoardService;
import notice.project.example.service.IExampleBoardService;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/board")
public class ExampleBoard extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        try {
            var service = ServiceFactory.createProxy(
                    IExampleBoardService.class,
                    ExampleBoardService.class
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
