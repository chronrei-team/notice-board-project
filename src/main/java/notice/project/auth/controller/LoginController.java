package notice.project.auth.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.DTO.LoginResponse;
import notice.project.auth.DTO.Token;
import notice.project.auth.service.AuthService;
import notice.project.auth.service.IAuthService;
import notice.project.core.ServiceFactory;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

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
        var redirectUrl = request.getParameter("redirectUrl");

        try {
            var user = authService.verifyLogin(userName, password);
            var session = request.getSession();
            session.setAttribute("token", new Token(user.id, user.userName, user.role));

            response.sendRedirect(redirectUrl != null ? redirectUrl : request.getContextPath() + "/");
        } catch (Exception e) {
            LoginResponse loginDO = new LoginResponse(e.getMessage());
            request.setAttribute("LoginResponse", loginDO);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
