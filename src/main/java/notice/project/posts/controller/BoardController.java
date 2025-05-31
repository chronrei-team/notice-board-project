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
        // 검색 기능 추가

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

            int extraPageCount = 4;
            int extraOffset = page * PAGE_SIZE;
            int extraLimit = PAGE_SIZE * extraPageCount;
            var extraPosts = service.getPostListExtra(extraOffset, extraLimit);

            int rightButtonsCount = 0;
            for (int i = 0; i < extraPageCount; i++) {
                int fromIndex = i * PAGE_SIZE;
                int toIndex = Math.min(fromIndex + PAGE_SIZE, extraPosts.size());
                if (toIndex - fromIndex == PAGE_SIZE) {
                    rightButtonsCount++;
                } else {
                    break;
                }
            }

            int totalButtons = 5;
            int leftButtonsCount = totalButtons - rightButtonsCount;

            int startPage = page - leftButtonsCount + 1;
            if (startPage < 1) startPage = 1;
            int endPage = page + rightButtonsCount;


            request.setAttribute("posts", resp);
            request.setAttribute("currentPage", page);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("totalButtons", totalButtons);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "데이터베이스 오류가 발생했습니다.");
        }
        catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", "사용자를 찾을 수 없습니다.");
        }
        request.getRequestDispatcher("/main_board.jsp").forward(request, response);
    }
}
