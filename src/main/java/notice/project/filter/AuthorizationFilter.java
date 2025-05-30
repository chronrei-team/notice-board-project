package notice.project.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        var session = ((HttpServletRequest)servletRequest).getSession(false);
        if (session != null) {
            var token = session.getAttribute("token");
            servletRequest.setAttribute("token", token);
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
