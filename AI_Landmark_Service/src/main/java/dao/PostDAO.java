package dao;

import model.Post; // Post.java 클래스를 사용하기 위해 import
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

    // ✅ 게시글 전체 조회 (작성자 닉네임 포함)
    public List<Post> getAllPosts() {
        List<Post> postList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT P.*, M.NICKNAME FROM POST P " +
                        "JOIN MEMBER M ON P.MEMBER_ID = M.MEMBER_ID " +
                        "ORDER BY P.POST_DATE DESC"; // 최신글이 먼저 오도록 정렬
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
                post.setNickname(rs.getString("NICKNAME")); // 작성자 닉네임 추가
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

            // 👇 [수정] POST_IMAGE_URL 컬럼과 값을 추가합니다. (DB 테이블에 해당 컬럼이 있어야 합니다)
            String sql = "INSERT INTO POST (POST_ID, CATEGORIES, TITLE, VIEWS, POST_DATE, POST_CONTENT, MEMBER_ID, POST_IMAGE_URL) " +
                         "VALUES ((SELECT NVL(MAX(POST_ID), 0) + 1 FROM POST), ?, ?, 0, SYSDATE, ?, ?, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, post.getCategories());
            pstmt.setString(2, post.getTitle());
            pstmt.setString(3, post.getPostContent());
            pstmt.setInt(4, post.getMemberId());
            
            // 👇 [추가] 5번째 물음표(?) 자리에 이미지 URL 값을 설정합니다.
            // Post 모델에 getPostImageUrl() 메소드가 있다고 가정합니다.
            pstmt.setString(5, post.getPostImageUrl());

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

 // ✅ 게시글 단일 조회 (작성자 닉네임 및 이미지 URL 포함)
    public Post getPostById(int postId) {
        Post post = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 👇 [수정] POST_IMAGE_URL 컬럼을 함께 SELECT 하도록 변경
            String sql = "SELECT P.*, M.NICKNAME FROM POST P " +
                         "JOIN MEMBER M ON P.MEMBER_ID = M.MEMBER_ID " +
                         "WHERE P.POST_ID = ?";
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
                post.setNickname(rs.getString("NICKNAME"));
                
                // 👇 [추가] DB에서 가져온 이미지 URL을 Post 객체에 저장합니다.
                post.setPostImageUrl(rs.getString("POST_IMAGE_URL"));
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

    // ✅ 특정 사용자가 작성한 게시글만 조회 (작성자 닉네임 포함)
    public List<Post> getPostsByMember(int memberId) {
        List<Post> postList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT P.*, M.NICKNAME FROM POST P " +
                        "JOIN MEMBER M ON P.MEMBER_ID = M.MEMBER_ID " +
                        "WHERE P.MEMBER_ID = ? ORDER BY P.POST_DATE DESC";
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
                post.setNickname(rs.getString("NICKNAME")); // 작성자 닉네임 추가
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

    // ✅ 게시글 검색 (제목, 내용, 작성자 닉네임으로 검색)
    public List<Post> searchPosts(String keyword) {
        List<Post> postList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT P.*, M.NICKNAME FROM POST P " +
                        "JOIN MEMBER M ON P.MEMBER_ID = M.MEMBER_ID " +
                        "WHERE P.TITLE LIKE ? OR P.POST_CONTENT LIKE ? OR M.NICKNAME LIKE ? " +
                        "ORDER BY P.POST_DATE DESC";
            pstmt = conn.prepareStatement(sql);
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            
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
                post.setNickname(rs.getString("NICKNAME")); // 작성자 닉네임 추가
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

    // ✅ 조회수 증가
    public boolean increaseViews(int postId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "UPDATE POST SET VIEWS = VIEWS + 1 WHERE POST_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);

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
        return result > 0;
    }
}
