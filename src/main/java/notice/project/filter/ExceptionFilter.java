package notice.project.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebFilter(urlPatterns = "/*", dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.ERROR})
public class ExceptionFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        try {
            filterChain.doFilter(servletRequest, servletResponse);
        }
        catch (Throwable e) {
            HttpServletRequest request = (HttpServletRequest) servletRequest;
            HttpServletResponse response = (HttpServletResponse) servletResponse;

            request.getSession().setAttribute("ErrMessage", e.getMessage() == null ? e.toString() : e.getMessage());
            String referer = request.getHeader("referer");
            if (referer == null || referer.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            response.sendRedirect(referer);
        }

    }
}
