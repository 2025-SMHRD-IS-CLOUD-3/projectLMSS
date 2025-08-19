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

    // ===== 회원정보 조회 (GET) =====
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser");  // 로그인 아이디 가져오기

        if (loginUser != null) {
            MemberDAO memberDAO = new MemberDAO();
            Member memberInfo = memberDAO.getMemberById(loginUser);

            request.setAttribute("memberInfo", memberInfo);
            // editProfile.jsp 대신 myProfile.jsp로 이동
            request.getRequestDispatcher("myProfile.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    // ===== 회원정보 수정 (POST) =====
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser"); // 로그인 아이디 가져오기

        String newPwd = request.getParameter("pwd");
        String newEmail = request.getParameter("email");

        MemberDAO dao = new MemberDAO();
        int result = dao.updateMemberPasswordAndEmail(loginUser, newPwd, newEmail);

        if (result > 0) {
            // 세션 최신화 (이메일 갱신)
            session.setAttribute("email", newEmail);

            // 성공 후 myProfile.jsp로 이동
            response.sendRedirect("myProfile.jsp?success=1");
        } else {
            response.sendRedirect("myProfile.jsp?error=1");
        }
    }
}
