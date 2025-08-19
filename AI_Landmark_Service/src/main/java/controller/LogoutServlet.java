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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 요청한 페이지 경로 확인
        String referer = request.getHeader("Referer"); // 로그아웃 누른 이전 페이지

        if (referer != null) {
            if (referer.contains("myProfile.jsp") || referer.contains("postwrite.jsp")) {
                // 마이페이지, 글작성 → main.jsp로 강제 이동
                response.sendRedirect(request.getContextPath() + "/main.jsp");
            } else {
                // 나머지는 원래 페이지로 이동
                response.sendRedirect(referer);
            }
        } else {
            // 예외적으로 referer가 없으면 main.jsp로
            response.sendRedirect(request.getContextPath() + "/main.jsp");
        }
    }
}
