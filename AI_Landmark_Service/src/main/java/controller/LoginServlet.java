package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login") // 경로 통일
public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // login.jsp에서 name="ID", name="PWD"로 넘어오기 때문에 대소문자 맞춤
        String id = request.getParameter("ID");
        String password = request.getParameter("PWD");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement pstmt = conn.prepareStatement("SELECT PWD FROM MEMBER WHERE ID = ?")) {

                pstmt.setString(1, id);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        String dbPassword = rs.getString("PWD");

                        if (password.equals(dbPassword)) {
                            // 로그인 성공 → 세션 저장
                            HttpSession session = request.getSession();
                            session.setAttribute("loginUser", id);

                            // 메인 페이지로 이동
                            response.sendRedirect(request.getContextPath() + "/main.jsp");
                            return;
                        } else {
                            // 비밀번호 불일치
                            request.setAttribute("loginError", "비밀번호가 틀렸습니다.");
                        }
                    } else {
                        // ID 없음
                        request.setAttribute("loginError", "등록된 아이디가 아닙니다.");
                    }
                }
            }

            // 실패 시 로그인 페이지로
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
