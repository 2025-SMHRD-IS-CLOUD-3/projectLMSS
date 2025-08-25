package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.File;
import java.util.UUID;

import model.Post;
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10)
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

            String sql = "SELECT POST_ID, TITLE, POST_CONTENT, CATEGORIES, POST_IMAGE_URL FROM POST WHERE POST_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setTitle(rs.getString("TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setCategories(rs.getString("CATEGORIES"));
                post.setPostImageUrl(rs.getString("POST_IMAGE_URL"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if (post == null) {
            response.sendRedirect(request.getContextPath() + "/postList");
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

        // 수정 후 리다이렉트 경로 유동 처리
        String redirectPage = request.getParameter("redirect"); // 예: myProfile, postList
        if (redirectPage == null || redirectPage.isEmpty()) {
            redirectPage = "postList"; // 기본: 게시판 목록
        }

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
                    response.sendRedirect(request.getContextPath() + "/postList?msg=deleteSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/postList?error=deleteFail");
                }
                return; // 삭제 처리 끝났으니 종료
            }

            // ===== 글 수정 SQL =====
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            
         // 👇 [추가] 새 이미지 파일 처리 로직
            Part filePart = request.getPart("postImage");
            String newImageUrl = null;

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                // ❗ PostWriteServlet과 동일한 외부 폴더 경로를 사용합니다.
                String uploadPath = "C:/landmark_uploads"; 
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String savedFileName = UUID.randomUUID().toString() + extension;
                filePart.write(uploadPath + File.separator + savedFileName);
                
                newImageUrl =  savedFileName; // DB에 저장할 새 파일 경로
            }

            // 👇 [수정] 새 이미지가 있는지 여부에 따라 SQL을 동적으로 변경합니다.
            String sql;
            if (newImageUrl != null) {
                sql = "UPDATE POST SET TITLE=?, POST_CONTENT=?, CATEGORIES=?, POST_IMAGE_URL=? WHERE POST_ID=?";
            } else {
                // 새 이미지가 없으면 이미지 URL은 업데이트하지 않습니다.
                sql = "UPDATE POST SET TITLE=?, POST_CONTENT=?, CATEGORIES=? WHERE POST_ID=?";
            }

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, category);

            if (newImageUrl != null) {
                pstmt.setString(4, newImageUrl);
                pstmt.setInt(5, postId);
            } else {
                pstmt.setInt(4, postId);
            }
            result = pstmt.executeUpdate();

        } catch (Exception e) {	
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if (result > 0) {
            if ("mypage".equals(redirectPage)) {
                response.sendRedirect(request.getContextPath() + "/myProfile.jsp");
            } else if ("postList".equals(redirectPage)) {
                response.sendRedirect(request.getContextPath() + "/postList");
            } else {
                response.sendRedirect(request.getContextPath() + "/postInfo?postId=" + postId);
            }
        }

    }
}
