package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // JSP에서 넘어온 값
        String id = request.getParameter("id");
        String pwd = request.getParameter("pwd");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String nickname = request.getParameter("nickname");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe",
                "campus_24IS_CLOUD3_p2_2",
                "smhrd2"
            );

            // 1. 아이디 중복 확인
            String checkIdSql = "SELECT COUNT(*) FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(checkIdSql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.println("<script>alert('이미 사용 중인 아이디입니다.');history.back();</script>");
                return; // 가입 중단
            }
            rs.close();
            pstmt.close();

            // 2. 닉네임 중복 확인
            String checkNicknameSql = "SELECT COUNT(*) FROM MEMBER WHERE NICKNAME = ?";
            pstmt = conn.prepareStatement(checkNicknameSql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.println("<script>alert('이미 사용 중인 닉네임입니다.');history.back();</script>");
                return; // 가입 중단
            }
            rs.close();
            pstmt.close();

            // 3. 중복이 없으면 회원 정보 삽입
            String insertSql = "INSERT INTO MEMBER (MEMBER_ID, ID, PWD, EMAIL, NAME, NICKNAME) " +
                               "VALUES (MEMBER_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, id);
            pstmt.setString(2, pwd);
            pstmt.setString(3, email);
            pstmt.setString(4, name);
            pstmt.setString(5, nickname);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>alert('회원가입 성공!');location.href='login.jsp';</script>");
            } else {
                out.println("<script>alert('회원가입 실패');history.back();</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('회원가입 실패: " + e.getMessage().replace("'", "\\'") + "');history.back();</script>");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<script>alert('JDBC 드라이버 로드 실패');history.back();</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}