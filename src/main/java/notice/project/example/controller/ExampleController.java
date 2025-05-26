package notice.project.example.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.ServiceFactory;
import notice.project.example.service.ExampleService;
import notice.project.example.service.IExampleService;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/example")
public class ExampleController extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        try {
            var service = ServiceFactory.createProxy(
                    IExampleService.class,
                    ExampleService.class
            );

            var resp = service.getName("336e7162-fac4-451f-a712-d570f046518b");


            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println("<h1>" + resp.getName() + "</h1>");
            out.println("</body></html>");

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        catch (UserNotFoundException e) {
            // 예외 처리
            throw new RuntimeException(e);
        }
    }
}
