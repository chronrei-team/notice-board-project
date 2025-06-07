package notice.project.my.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import notice.project.auth.DTO.Token;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;
import notice.project.my.DO.UserResponse;
import notice.project.my.service.IMyService;
import notice.project.my.service.MyService;

import java.io.IOException;

@WebServlet("/my/withdraw")
public class DeleteController extends AuthBaseServlet {
    private IMyService myService;

    @Override
    public void init() throws ServletException {
        super.init();
        myService = ServiceFactory.createProxy(IMyService.class, MyService.class);
    }

    @Override
    @Authorization
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("token") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        var token = (Token) session.getAttribute("token");
        String userName = token.getUserName();
        String password = request.getParameter("password");

        UserResponse userResponse;

        try {
            // 회원 탈퇴 서비스 호출
            myService.withdrawUser(userName, password);

            // 탈퇴 성공 시 세션 무효화 및 성공 메시지 처리
            session.invalidate();

            userResponse = new UserResponse(null, "회원 탈퇴가 정상적으로 처리되었습니다.");

            // 탈퇴 후에는 보통 로그인 페이지 또는 메인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login?message=withdraw_success");
            return;

        } catch (Exception e) {
            userResponse = new UserResponse(e.getMessage(), null);
        }

        request.setAttribute("UserResponse", userResponse);
        // 탈퇴 실패 시 다시 정보 수정 페이지나 별도의 페이지로 포워딩 가능
        request.getRequestDispatcher("/profile_edit.jsp").forward(request, response);
    }
}
