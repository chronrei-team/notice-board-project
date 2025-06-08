package notice.project.auth.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/auth/logout")
public class LogoutController extends AuthBaseServlet {
    @Override
    @Authorization
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().invalidate();
        var redirectUrl = request.getParameter("redirectUrl");
        response.sendRedirect(redirectUrl == null ? request.getContextPath() + "/" : redirectUrl);
    }
}
