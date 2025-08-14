package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/getUserInfo")
public class GetUserInfoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // JSON 반환 설정
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false); // false → 세션 없으면 null 반환
        String username = null;

        if (session != null) {
            username = (String) session.getAttribute("loggedInUser");
        }

        if (username != null) {
            // 로그인 되어 있음
            response.getWriter().write("{\"username\":\"" + username + "\"}");
        } else {
            // 로그인 안됨
            response.getWriter().write("{\"username\":null}");
        }
    }
}
