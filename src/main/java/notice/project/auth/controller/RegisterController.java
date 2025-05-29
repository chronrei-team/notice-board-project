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
    private static final String REGEX_HAS_WHITESPACE_OR_SPECIAL_CHAR = ".*\\s.*|.*[^a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s].*";

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
            if (userName == null || hasWhitespaceOrSpecialChar(userName)) {
                throw new InvalidUserNameException();
            }
            if (password == null) {
                throw new PasswordNotFoundException();
            }

            authService.register(userName, password);
            registerDO = new RegisterResponse(null, "회원가입에 성공하였습니다!",
                    null, null);

        } catch (InvalidUserNameException e) {
            registerDO = new RegisterResponse("닉네임은 특수문자 및 공백을 포함할 수 없습니다.", null,
                    userName, password);
        } catch (PasswordNotFoundException e) {
            registerDO = new RegisterResponse("비밀번호를 입력해 주세요.", null,
                    userName, password);
        } catch (AlreadyRegistedException e) {
            registerDO = new RegisterResponse("이미 사용중인 닉네임 입니다.", null,
                    userName, password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        request.setAttribute("RegisterResponse", registerDO);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private static boolean hasWhitespaceOrSpecialChar(String input) {
        if (input == null) {
            return false;
        }
        Pattern pattern = Pattern.compile(REGEX_HAS_WHITESPACE_OR_SPECIAL_CHAR);
        Matcher matcher = pattern.matcher(input);
        return matcher.matches();
    }
}
