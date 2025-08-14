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
    private static final String DB_PASSWORD = "smhrd2"; // 본인 비밀번호

    @Override
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

            String sql = "SELECT PWD FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("PWD");

                if (password.equals(dbPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedInUser", id);

                    // JSP로 리다이렉트
                    response.sendRedirect(request.getContextPath() + "/loginmain.jsp");
                } else {
                    request.setAttribute("loginError", "비밀번호가 틀렸습니다.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("loginError", "등록된 아이디가 아닙니다.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        } finally {
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
