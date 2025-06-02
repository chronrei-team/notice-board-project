package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.ServiceFactory;
import notice.project.posts.DTO.BoardResponse;
import notice.project.posts.DTO.PageResponse;
import notice.project.posts.service.BoardService;
import notice.project.posts.service.IBoardService;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/")
public class BoardController extends HttpServlet {
    private static final int PAGE_SIZE = 1; //테스트를 위해 1로 설정. 기본 10
    private static final int TOTAL_BUTTONS = 5;
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

            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");

            IBoardService service = ServiceFactory.createProxy(
                    IBoardService.class,
                    BoardService.class
            );

            PageResponse<BoardResponse> pageResult;

            if (keyword != null && !keyword.isBlank()) {
                // 검색 기능 수행
                if (type == null || type.isBlank()) {
                    type = "title"; // 기본값 설정
                }
                pageResult = service.searchPostsWithPagination(keyword, type, page, PAGE_SIZE, TOTAL_BUTTONS);
                request.setAttribute("keyword", keyword);
                request.setAttribute("type", type);
            } else {
                // 일반 목록 조회
                pageResult = service.getPostListWithPagination(page, PAGE_SIZE, TOTAL_BUTTONS);
            }


            request.setAttribute("pageResult", pageResult);
            request.setAttribute("currentPage", page);


        } catch (IllegalArgumentException e) {
            // 👉 잘못된 페이지 접근 시 알림 후 첫 페이지로 리디렉션
            request.getSession().setAttribute("alertMessage", "존재하지 않는 페이지입니다.");
            response.sendRedirect(request.getContextPath() + "/?page=1");
            return;
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "데이터베이스 오류가 발생했습니다.");
        }
        catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", "사용자를 찾을 수 없습니다.");
        }
        request.getRequestDispatcher("/main_board.jsp").forward(request, response);
    }
}
