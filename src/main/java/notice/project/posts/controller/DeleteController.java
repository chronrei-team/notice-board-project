package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.ServiceFactory;
import notice.project.posts.service.BoardService;
import notice.project.posts.service.IBoardService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/board/deletePost")
public class DeleteController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        IBoardService service = ServiceFactory.createProxy(IBoardService.class, BoardService.class);
        try {
            service.deletePost(id);
            response.sendRedirect(request.getContextPath() + "/"); // 삭제 후 메인으로 이동
        } catch (SQLException e) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("""
                <script>
                    alert('삭제 중 오류가 발생했습니다.');
                    history.back();  // 이전 페이지로 돌아감
                </script>
            """);
        }
    }
}
