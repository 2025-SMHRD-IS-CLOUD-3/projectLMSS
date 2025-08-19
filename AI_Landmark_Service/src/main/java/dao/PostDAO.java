package dao;

import model.Post; // Post.java 클래스를 사용하기 위해 import
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

    // ✅ 게시글 전체 조회
    public List<Post> getAllPosts() {
        List<Post> postList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM POST ORDER BY POST_DATE DESC"; // 최신글이 먼저 오도록 정렬
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setCategories(rs.getString("CATEGORIES"));
                post.setTitle(rs.getString("TITLE"));
                post.setViews(rs.getInt("VIEWS"));
                post.setPostDate(rs.getDate("POST_DATE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setMemberId(rs.getInt("MEMBER_ID"));
                postList.add(post);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return postList;
    }

    // ✅ 게시글 등록
    public int insertPost(Post post) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "INSERT INTO POST (POST_ID, CATEGORIES, TITLE, VIEWS, POST_DATE, POST_CONTENT, MEMBER_ID) " +
                         "VALUES (POST_SEQ.NEXTVAL, ?, ?, 0, SYSDATE, ?, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, post.getCategories());
            pstmt.setString(2, post.getTitle());
            pstmt.setString(3, post.getPostContent());
            pstmt.setInt(4, post.getMemberId());

            result = pstmt.executeUpdate();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result; // 1이면 성공, 0이면 실패
    }

    // ✅ 게시글 단일 조회
    public Post getPostById(int postId) {
        Post post = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM POST WHERE POST_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setCategories(rs.getString("CATEGORIES"));
                post.setTitle(rs.getString("TITLE"));
                post.setViews(rs.getInt("VIEWS"));
                post.setPostDate(rs.getDate("POST_DATE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setMemberId(rs.getInt("MEMBER_ID"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return post;
    }

    // ✅ 특정 사용자가 작성한 게시글만 조회
    public List<Post> getPostsByMember(int memberId) {
        List<Post> postList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM POST WHERE MEMBER_ID = ? ORDER BY POST_DATE DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setCategories(rs.getString("CATEGORIES"));
                post.setTitle(rs.getString("TITLE"));
                post.setViews(rs.getInt("VIEWS"));
                post.setPostDate(rs.getDate("POST_DATE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setMemberId(rs.getInt("MEMBER_ID"));
                postList.add(post);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return postList;
    }
}
