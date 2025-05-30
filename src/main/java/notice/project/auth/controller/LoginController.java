package notice.project.auth.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.DTO.LoginResponse;
import notice.project.auth.service.AuthService;
import notice.project.auth.service.IAuthService;
import notice.project.core.ServiceFactory;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.UserNotFoundException;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

@WebServlet("/auth/login")
public class LoginController extends HttpServlet {
    private IAuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = ServiceFactory.createProxy(IAuthService.class, AuthService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        var userName = request.getParameter("userName");
        var password = request.getParameter("password");

        try {
            var user = authService.verifyLogin(userName, password);
            var session = request.getSession();
            session.setAttribute("token", user);

            response.sendRedirect(request.getContextPath() + "/");
        } catch (UserNotFoundException e) {
            LoginResponse loginDO = new LoginResponse("유저가 존재하지 않습니다.",
                    userName, password);
            request.setAttribute("LoginResponse", loginDO);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (InvalidPasswordException e) {
            LoginResponse loginDO = new LoginResponse("비밀번호가 일치하지 않습니다.",
                    userName, password);
            request.setAttribute("LoginResponse", loginDO);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
        catch (Exception e) {
            LoginResponse loginDO = new LoginResponse("알 수 없는 오류가 발생했습니다.",
                    userName, password);
            request.setAttribute("LoginResponse", loginDO);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
