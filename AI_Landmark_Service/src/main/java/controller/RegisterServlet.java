package controller;

import dao.MemberDAO; // MemberDAO 임포트
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register") // register.jsp의 form action과 동일하게 설정
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // JSP에서 넘어온 한글 데이터가 깨지지 않도록 인코딩 설정

        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String nickname = request.getParameter("nickname");

        MemberDAO memberDAO = new MemberDAO(); // MemberDAO 객체 생성

        // 1. 아이디 중복 확인
        if (memberDAO.isIdDuplicate(id)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('이미 사용 중인 아이디입니다.'); history.back();</script>");
            return;
        }

        // 2. 닉네임 중복 확인
        if (memberDAO.isNicknameDuplicate(nickname)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('이미 사용 중인 닉네임입니다.'); history.back();</script>");
            return;
        }

        // 3. 이메일 중복 확인
        if (memberDAO.isEmailDuplicate(email)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('이미 사용 중인 이메일입니다.'); history.back();</script>");
            return;
        }

        // 중복이 없을 경우, 회원 등록 진행
        boolean registrationSuccess = memberDAO.registerMember(id, password, email, name, nickname);

        if (registrationSuccess) {
            // 회원가입 성공 시 메시지 출력 후 로그인 페이지로 이동
            response.setContentType("text/html;charset=UTF-8"); // 한글 메시지를 위해 Content-Type 설정
            response.getWriter().write("<script>alert('회원가입성공했습니다.'); window.location.href='login.jsp';</script>");
        } else {
            // 회원가입 실패 시 error.jsp로 이동
            response.sendRedirect("error.jsp");
        }
    }
}
