package controller;

import dao.MemberDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deleteMember")
public class DeleteMemberServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // myProfile.jsp에서 숨겨진 필드로 전달된 ID와 사용자가 입력한 비밀번호를 받음
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        MemberDAO memberDAO = new MemberDAO();
        boolean deleteSuccess = memberDAO.deleteMember(id, password); // ID와 비밀번호로 탈퇴 처리

        response.setContentType("text/html;charset=UTF-8");

        if (deleteSuccess) {
            // 회원 탈퇴 성공 시 세션 무효화 (로그아웃 처리)
            HttpSession session = request.getSession(false); // 기존 세션이 있으면 가져옴
            if (session != null) {
                session.invalidate(); // 세션 무효화
            }
            response.getWriter().write("<script>alert('회원 탈퇴가 완료되었습니다.'); window.location.href='index.jsp';</script>");
        } else {
            // 탈퇴 실패 시 메시지 출력 후 이전 페이지(myProfile.jsp)로 돌아감
            response.getWriter().write("<script>alert('아이디 또는 비밀번호가 일치하지 않아 탈퇴에 실패했습니다.'); history.back();</script>");
        }
    }
}
