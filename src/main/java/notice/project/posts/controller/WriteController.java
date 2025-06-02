package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import notice.project.core.AuthBaseServlet;
import notice.project.core.Authorization;

import java.io.IOException;

@WebServlet("/board/write")
public class WriteController extends AuthBaseServlet {

    @Authorization
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/write.jsp").forward(request, response);
    }

    @Authorization
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) {

    }
}
