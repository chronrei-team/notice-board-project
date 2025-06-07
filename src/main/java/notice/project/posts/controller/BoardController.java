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
import notice.project.utils.HighlightUtil;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/")
public class BoardController extends HttpServlet {
    private static final int PAGE_SIZE = 2; //테스트를 위해 1로 설정. 기본 10
    private static final int TOTAL_BUTTONS = 5;
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");
        String categoryParam = request.getParameter("category");

        try {
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }

            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");
            String op = request.getParameter("op");

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
                pageResult = service.searchPostsWithPagination(keyword, type, op, categoryParam, page, PAGE_SIZE, TOTAL_BUTTONS);
                for (BoardResponse post : pageResult.getData()) {
                    if ("title".equals(type)) {
                        post.setHighlightedTitle(HighlightUtil.highlight(post.getTitle(), keyword));
                    }
                    else if ("author".equals(type)) {
                        post.setHighlightedUserName(HighlightUtil.highlight(post.getUserName(), keyword));
                    }
                }
                request.setAttribute("keyword", keyword);
                request.setAttribute("type", type);
                request.setAttribute("op", op);
            } else {
                // 일반 목록 조회
                pageResult = service.getPostListWithPagination(categoryParam, page, PAGE_SIZE, TOTAL_BUTTONS);
            }

            int maxMovablePage = service.calculateMaxMovablePage(categoryParam, page, PAGE_SIZE, TOTAL_BUTTONS);

            request.setAttribute("category", categoryParam);
            request.setAttribute("pageResult", pageResult);
            request.setAttribute("posts", pageResult.getData());
            request.setAttribute("notices", pageResult.getFixedNotices());
            request.setAttribute("currentPage", page);
            request.setAttribute("maxMovablePage", maxMovablePage);

            // ✅ 게시글이 없으면 'empty', 있으면 'ok'
            if (pageResult.getData() == null || pageResult.getData().isEmpty()) {
                request.setAttribute("postStatus", "empty");
            } else {
                request.setAttribute("postStatus", "ok");
            }


        } catch (SQLException e) {
            throw new RuntimeException(e.getMessage());
        }

        request.getRequestDispatcher("/main_board.jsp").forward(request, response);
    }
}
