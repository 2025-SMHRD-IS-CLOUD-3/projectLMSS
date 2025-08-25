package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import model.Member;
import dao.MemberDAO;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ===== 회원정보 조회 및 탈퇴 (GET) =====
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser");
        String action = request.getParameter("action"); // 'action' 파라미터 값 가져오기

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- 회원 탈퇴 로직 ---
        if ("delete".equals(action)) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe",
                    "campus_24IS_CLOUD3_p2_2",
                    "smhrd2"
                );

                // 외래 키 제약 조건 해결: 관련된 데이터를 먼저 삭제
                // 1. 즐겨찾기 삭제
                String sqlDeleteFavorites = "DELETE FROM FAVORITES WHERE MEMBER_ID = (SELECT MEMBER_ID FROM MEMBER WHERE ID = ?)";
                pstmt = conn.prepareStatement(sqlDeleteFavorites);
                pstmt.setString(1, loginUser);
                pstmt.executeUpdate();
                if (pstmt != null) pstmt.close();

                // 2. 댓글 삭제
                String sqlDeleteReplies = "DELETE FROM REPLY WHERE MEMBER_ID = (SELECT MEMBER_ID FROM MEMBER WHERE ID = ?)";
                pstmt = conn.prepareStatement(sqlDeleteReplies);
                pstmt.setString(1, loginUser);
                pstmt.executeUpdate();
                if (pstmt != null) pstmt.close();

                // 3. 게시글 삭제
                String sqlDeletePosts = "DELETE FROM POST WHERE MEMBER_ID = (SELECT MEMBER_ID FROM MEMBER WHERE ID = ?)";
                pstmt = conn.prepareStatement(sqlDeletePosts);
                pstmt.setString(1, loginUser);
                pstmt.executeUpdate();
                if (pstmt != null) pstmt.close();

                // 4. 마지막으로 회원 정보 삭제
                String sqlDeleteMember = "DELETE FROM MEMBER WHERE ID = ?";
                pstmt = conn.prepareStatement(sqlDeleteMember);
                pstmt.setString(1, loginUser);
                pstmt.executeUpdate();

                // 세션 무효화 (로그아웃 처리)
                session.invalidate();

                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('회원탈퇴가 완료되었습니다.'); location.href='main.jsp';</script>");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('회원탈퇴 중 오류가 발생했습니다.'); history.back();</script>");
                return;
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        }
        
        // 'action=delete' 요청이 아닐 경우, 기존의 회원 정보 조회 로직을 수행합니다.
        MemberDAO memberDAO = new MemberDAO();
        Member memberInfo = memberDAO.getMemberById(loginUser);

        request.setAttribute("memberInfo", memberInfo);
        request.getRequestDispatcher("myProfile.jsp").forward(request, response);
    }

    // ===== 회원정보 수정 (POST) =====
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser");

        String newPwd = request.getParameter("pwd");
        String newNickname = request.getParameter("nickname"); // 닉네임 값 가져오기
        String newEmail = request.getParameter("email");

        MemberDAO dao = new MemberDAO();
        int result = dao.updateMemberPasswordAndEmailAndNickname(loginUser, newPwd, newNickname, newEmail);

        if (result > 0) {
            // 세션 최신화 (이메일, 닉네임 갱신)
            session.setAttribute("email", newEmail);
            session.setAttribute("nickname", newNickname);

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('회원 정보가 성공적으로 수정되었습니다.'); location.href='myProfile.jsp';</script>");
        } else {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('회원 정보 수정에 실패했습니다.'); history.back();</script>");
        }
    }
}