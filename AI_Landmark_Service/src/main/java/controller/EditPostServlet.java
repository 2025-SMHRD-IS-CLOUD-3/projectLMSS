package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Post;

@WebServlet("/postEdit")
public class EditPostServlet extends HttpServlet {

    // ===== 글 수정 페이지 열기 =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
        	response.sendRedirect(request.getContextPath() + "/postList");
            return;
        }

        int postId = Integer.parseInt(postIdStr);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Post post = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe",
                "campus_24IS_CLOUD3_p2_2",
                "smhrd2"
            );

            String sql = "SELECT POST_ID, TITLE, POST_CONTENT, CATEGORIES FROM POST WHERE POST_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setTitle(rs.getString("TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setCategories(rs.getString("CATEGORIES"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if (post == null) {
            response.sendRedirect("postList");
            return;
        }

        // request에 글 정보 저장 후 JSP로 포워드
        request.setAttribute("post", post);
        request.getRequestDispatcher("/WEB-INF/postEdit.jsp").forward(request, response);
    }

    // ===== 글 수정 & 삭제 처리 =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action"); // 수정 or 삭제 구분
        String postIdStr = request.getParameter("postId");
        int postId = (postIdStr != null && !postIdStr.isEmpty()) ? Integer.parseInt(postIdStr) : -1;

        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe",
                "campus_24IS_CLOUD3_p2_2",
                "smhrd2"
            );

            if ("delete".equals(action)) {
                // ===== 글 삭제 SQL =====
                String sql = "DELETE FROM POST WHERE POST_ID=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, postId);
                result = pstmt.executeUpdate();

                if (result > 0) {
                    // 삭제 성공 → 목록으로 이동
                    response.sendRedirect(request.getContextPath() + "/postList?msg=deleteSuccess");
                } else {
                    // 실패
                    response.sendRedirect(request.getContextPath() + "/postList?error=deleteFail");
                }
                return; // 삭제 처리 끝났으니 여기서 메서드 종료
            }

            // ===== 글 수정 SQL =====
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");

            String sql = "UPDATE POST SET TITLE=?, POST_CONTENT=?, CATEGORIES=? WHERE POST_ID=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, category);
            pstmt.setInt(4, postId);

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if(result > 0) {
            // 수정 성공 → 상세보기 페이지로 이동
            response.sendRedirect(request.getContextPath() + "/postInfo?id=" + postId);
        } else {
            // 실패 → 목록으로 이동
            response.sendRedirect(request.getContextPath() + "/postList?error=updateFail");
        }
    }
}
