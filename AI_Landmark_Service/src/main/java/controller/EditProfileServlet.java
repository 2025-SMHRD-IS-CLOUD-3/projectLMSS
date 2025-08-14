package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import model.Member;
import dao.MemberDAO;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String memberId = (String) session.getAttribute("id");

        if (memberId != null) {
            MemberDAO memberDAO = new MemberDAO();
            Member memberInfo = memberDAO.getMemberById(memberId);

            request.setAttribute("memberInfo", memberInfo);
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        } else {
            // 세션이 없으면 로그인 페이지로 리다이렉트
            response.sendRedirect("login.jsp");
        }
    }
}