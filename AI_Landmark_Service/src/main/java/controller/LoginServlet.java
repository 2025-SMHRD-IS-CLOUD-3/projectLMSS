package controller;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 1. 아이디만 먼저 확인하는 SQL 쿼리
            String sql = "SELECT PWD FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();


            
            if (rs.next()) {
                // 아이디가 존재할 경우
                String dbPassword = rs.getString("PWD");
                System.out.println("DB조회된 PWD: "+dbPassword);
                if (password.equals(dbPassword)) {
                    // 비밀번호도 일치할 경우 (로그인 성공)
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedInUser", id);
                    response.sendRedirect("main.jsp");
                } else {
                    // 비밀번호가 일치하지 않을 경우
                    request.setAttribute("loginError", "비밀번호가 틀렸습니다.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // 아이디가 존재하지 않을 경우
                request.setAttribute("loginError", "등록된 아이디가 아닙니다.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            // ... 자원 반납 코드
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}