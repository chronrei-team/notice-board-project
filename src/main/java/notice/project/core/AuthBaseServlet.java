package notice.project.core;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.Method;

public abstract class AuthBaseServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. 현재 요청에 해당하는 메서드(doGet, doPost 등) 이름을 결정합니다.
        String httpMethodName = req.getMethod(); // "GET", "POST" 등
        String servletMethodName = "do" + httpMethodName.substring(0, 1).toUpperCase() +
                httpMethodName.substring(1).toLowerCase(); // "doGet", "doPost"

        try {
            // 2. 현재 서블릿 클래스(this.getClass())에서 해당 메서드를 찾습니다.
            //    getDeclaredMethod를 사용해야 상속받은 HttpServlet의 메서드가 아닌,
            //    실제 구현 클래스(예: MySecureServlet)에 선언된 메서드를 찾습니다.
            Method targetMethod = this.getClass().getDeclaredMethod(servletMethodName,
                    HttpServletRequest.class,
                    HttpServletResponse.class);

            // 3. 해당 메서드에 @Authorization 어노테이션이 있는지 확인합니다.
            if (targetMethod.isAnnotationPresent(Authorization.class)) {
                HttpSession session = req.getSession(false); // 세션이 없으면 새로 생성하지 않음

                if (session == null || session.getAttribute("token") == null) {
                    // 로그인 페이지로 리다이렉트
                    resp.sendRedirect(req.getContextPath() + "/auth/login");
                    return; // 메서드 실행 중단
                }
            }
        } catch (NoSuchMethodException e) {
            // 이 경우는 보통 서블릿이 doGet, doPost 등을 오버라이드하지 않았을 때 발생합니다.
            // (예: GET 요청인데 서블릿에 doGet() 메서드가 없음).
            // 이 경우 @Authorization 어노테이션이 붙어있을 수 없으므로, HttpServlet의 기본 동작에 맡깁니다.
            // 특별한 처리가 필요 없다면 그냥 super.service()로 넘어갑니다.
        }

        // 어노테이션 검사를 통과했거나, 어노테이션이 없거나, 메서드를 찾지 못한 경우(HttpServlet 기본 동작)
        // HttpServlet의 service 메서드를 호출하여 실제 doGet, doPost 등을 실행합니다.
        super.service(req, resp);
    }
}