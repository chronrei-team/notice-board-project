package notice.project.auth.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.DTO.RegisterResponse;
import notice.project.auth.service.AuthService;
import notice.project.auth.service.IAuthService;
import notice.project.core.ServiceFactory;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidUserNameException;
import notice.project.exceptions.PasswordNotFoundException;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/auth/register")
public class RegisterController extends HttpServlet {
    private IAuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = ServiceFactory.createProxy(IAuthService.class, AuthService.class);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        var userName = request.getParameter("userName");
        var password = request.getParameter("password");
        RegisterResponse registerDO = null;

        try {
            if (password == null) {
                throw new PasswordNotFoundException();
            }

            authService.register(userName, password);
            registerDO = new RegisterResponse(null, "회원가입에 성공하였습니다!");

        } catch (InvalidUserNameException e) {
            registerDO = new RegisterResponse("닉네임은 특수문자 및 공백을 포함할 수 없습니다.", null);
        } catch (PasswordNotFoundException e) {
            registerDO = new RegisterResponse("비밀번호를 입력해 주세요.", null);
        } catch (AlreadyRegistedException e) {
            registerDO = new RegisterResponse("이미 사용중인 닉네임 입니다.", null);
        } catch (Exception e) {
            registerDO = new RegisterResponse("알 수 없는 오류가 발생했습니다.", null);
        }

        request.setAttribute("RegisterResponse", registerDO);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

}
