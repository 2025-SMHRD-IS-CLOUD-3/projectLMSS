package controller;

import dao.MemberDAO;
import model.Member; // Member 모델 클래스 import
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/myProfile")
public class MyProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // 기존 세션 가져오기 (없으면 null 반환)

        if (session != null && session.getAttribute("loggedInUser") != null) {
            String loggedInUserId = (String) session.getAttribute("loggedInUser"); // 로그인된 사용자 ID 가져오기

            MemberDAO memberDAO = new MemberDAO();
            Member memberInfo = memberDAO.getMemberById(loggedInUserId); // 회원 정보 조회

            if (memberInfo != null) {
                request.setAttribute("memberInfo", memberInfo); // request에 회원 정보 저장
                request.getRequestDispatcher("myProfile.jsp").forward(request, response); // myProfile.jsp로 포워딩
            } else {
                // 회원 정보를 찾을 수 없는 경우 (데이터베이스 오류 등)
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<script>alert('회원 정보를 찾을 수 없습니다. 다시 로그인해주세요.'); window.location.href='login.jsp';</script>");
            }
        } else {
            // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            response.sendRedirect("login.jsp");
        }
    }
}
