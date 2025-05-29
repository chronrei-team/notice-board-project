package notice.project.example.controller;

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
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        try {
            var service = ServiceFactory.createProxy(
                    IExampleBoardService.class,
                    ExampleBoardService.class
            );

            var resp = service.getPostList();


            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println("<h1>게시판 목록</h1>");
            out.println("<table border='1'>");
            out.println("<tr><th>번호</th><th>제목</th><th>작성자</th><th>작성일</th><th>조회수</th><th>추천수</th></tr>");
            for (var post : resp) {
                out.println("<tr>");
                out.println("<td>" + post.getId() + "</td>");
                out.println("<td><a href='/board?id=" + post.getId() + "'>" + post.getTitle() + "</a></td>");
                out.println("<td>" + post.getUserId() + "</td>");
                out.println("<td>" + post.getCreatedAt() + "</td>");
                out.println("<td>" + post.getViewCount() + "</td>");
                out.println("<td>" + post.getRecommendCount() + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
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
