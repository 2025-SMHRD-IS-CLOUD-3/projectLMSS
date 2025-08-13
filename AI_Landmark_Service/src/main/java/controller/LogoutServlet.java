package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 기존 세션이 있으면 가져오고, 없으면 만들지 않음
        HttpSession session = request.getSession(false);

        // 세션이 null이 아니면(로그인 상태이면)
        if (session != null) {
            // 세션을 무효화하여 모든 세션 데이터를 삭제
            session.invalidate();
        }
        
        // 로그인 페이지로 리다이렉트
        response.sendRedirect("login.jsp");
    }
}