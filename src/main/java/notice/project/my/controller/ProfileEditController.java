package notice.project.my.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.auth.service.AuthService;
import notice.project.auth.service.IAuthService;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;
import notice.project.entity.Users;
import notice.project.exceptions.AlreadyRegistedException;
import notice.project.exceptions.InvalidPasswordException;
import notice.project.exceptions.InvalidUserNameException;
import notice.project.exceptions.UserNotFoundException;
import notice.project.my.DO.UserResponse;
import notice.project.my.service.IMyService;
import notice.project.my.service.MyService;

import java.io.IOException;

@WebServlet("/my/update")
public class ProfileEditController extends AuthBaseServlet {
    private IMyService myService;

    @Override
    public void init() throws ServletException {
        super.init();
        myService = ServiceFactory.createProxy(IMyService.class, MyService.class);
    }

    @Override
    @Authorization
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var token = (Users) request.getSession(false).getAttribute("token");
        request.setAttribute("UserResponse", new UserResponse(token.userName, null,
                null, null, null, null));
        request.getRequestDispatcher("/profile_edit.jsp").forward(request, response);
    }

    @Override
    @Authorization
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var token = (Users) request.getSession(false).getAttribute("token");
        var userName = token.userName;
        UserResponse userDO = null;

        try {
            var user = myService.profileUpdate(userName, request.getParameter("userName"),
                    request.getParameter("currentPassword"), request.getParameter("newPassword"));
            userDO = new UserResponse(
                    request.getParameter("userName"),
                    null,
                    null,
                    null,
                    null,
                    "유저 정보가 수정되었습니다.");

            request.getSession(false).setAttribute("token", user);
            request.setAttribute("token", user);

        } catch (Exception | InvalidUserNameException | UserNotFoundException
                 | AlreadyRegistedException | InvalidPasswordException e) {

            String failMessage = null;
            if (e instanceof InvalidUserNameException) {
                failMessage = "닉네임은 특수문자 및 공백을 포함할 수 없습니다.";
            }
            else if (e instanceof UserNotFoundException) {
                failMessage = "유저를 찾을 수 없습니다.";
            }
            else if (e instanceof AlreadyRegistedException) {
                failMessage = "이미 사용중인 닉네임 입니다.";
            }
            else if (e instanceof InvalidPasswordException) {
                failMessage = "비밀번호가 일치하지 않습니다.";
            }

            userDO = new UserResponse(
                    userName,
                    request.getParameter("userName"),
                    request.getParameter("currentPassword"),
                    request.getParameter("newPassword"),
                    failMessage,
                    null);
        }

        request.setAttribute("UserResponse", userDO);
        request.getRequestDispatcher("/profile_edit.jsp").forward(request, response);
    }
}
