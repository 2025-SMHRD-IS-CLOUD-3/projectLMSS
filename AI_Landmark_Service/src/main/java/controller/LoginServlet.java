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
    private static final String DB_PASSWORD = "smhrd2";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== LoginServlet doPost 호출됨 ===");
        System.out.println("요청 URL: " + request.getRequestURL());
        System.out.println("요청 URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        // 테스트용 코드 (필요시 주석 해제)
        /*
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<h1>LoginServlet이 호출되었습니다!</h1>");
        return;
        */
        
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("ID");
        String password = request.getParameter("PWD");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement pstmt = conn.prepareStatement(
                         "SELECT MEMBER_ID, PWD FROM MEMBER WHERE ID = ?")) {

                pstmt.setString(1, id);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        int memberId = rs.getInt("MEMBER_ID"); // PK
                        String dbPassword = rs.getString("PWD");

                        if (password.equals(dbPassword)) {
                            // ✅ 로그인 성공 → 세션에 로그인 정보 저장
                            HttpSession session = request.getSession();
                            session.setAttribute("loginUser", id);       // 로그인 아이디
                            session.setAttribute("memberId", memberId); // 숫자 PK

                            // ✅ 로그인 후 이동할 URL 확인 (파라미터 기반)
                            String redirect = request.getParameter("redirect");

                            if (redirect != null && !redirect.trim().isEmpty()) {
                                // /postList 같은 서블릿 매핑 경로로 이동
                                response.sendRedirect(request.getContextPath() + "/" + redirect);
                            } else {
                                // 기본 이동: 메인
                                response.sendRedirect(request.getContextPath() + "/main.jsp");
                            }

                            return;

                        } else {
                            // 비밀번호 틀림
                            request.setAttribute("loginError", "비밀번호가 틀렸습니다.");
                        }
                    } else {
                        // 아이디 없음
                        request.setAttribute("loginError", "등록된 아이디가 아닙니다.");
                    }
                }
            }

            // 실패 → 다시 로그인 페이지로
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
