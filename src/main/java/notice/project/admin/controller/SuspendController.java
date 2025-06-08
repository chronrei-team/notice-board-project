package notice.project.admin.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.admin.service.AdminService;
import notice.project.admin.service.IAdminService;
import notice.project.auth.DTO.Token;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;
import notice.project.core.ServiceFactory;
import notice.project.entity.UserRole;

import java.io.IOException;
import java.rmi.RemoteException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/admin/suspendUser")
public class SuspendController extends AuthBaseServlet {
    private IAdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = ServiceFactory.createProxy(IAdminService.class, AdminService.class);
    }

    @Override
    @Authorization
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        var token = (Token)request.getSession(false).getAttribute("token");
        if (token.getRole() != UserRole.Admin) throw new RuntimeException("권한이 없습니다.");

        var userId = request.getParameter("userId");
        var suspensionPeriod = request.getParameter("suspensionPeriod");
        var suspensionReason = request.getParameter("suspensionReason");

        if (userId == null || userId.isEmpty() || suspensionPeriod == null || suspensionPeriod.isEmpty()) {
            throw new RemoteException("정보가 부족합니다.");
        }

        var suspendedEndAt = Integer.parseInt(suspensionPeriod) > 0
                ? LocalDateTime.now().plusDays(Integer.parseInt(suspensionPeriod))
                : null;

        try {
            adminService.suspendUser(userId, suspendedEndAt, suspensionReason);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
