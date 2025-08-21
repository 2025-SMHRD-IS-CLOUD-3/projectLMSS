package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Reply;

public class ReplyDAO {
	private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
	private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
	private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

	// 랜드마크에 대한 댓글 가져오기
	public List<Reply> getReplyByLandmarkId(int landmarkId) {
		List<Reply> replyList = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

			String sql = "SELECT R.*, M.NICKNAME FROM REPLY R " +
                    "JOIN MEMBER M ON R.MEMBER_ID = M.MEMBER_ID " +
                    "WHERE R.LANDMARK_ID = ? ORDER BY R.REPLY_DATE DESC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, landmarkId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Reply reply = new Reply();
				
				reply.setReply_id(rs.getInt("REPLY_ID"));
                reply.setMember_id(rs.getInt("MEMBER_ID"));
                reply.setLandmark_id(rs.getInt("LANDMARK_ID"));
                reply.setPost_id(rs.getInt("POST_ID"));
                reply.setReply_content(rs.getString("REPLY_CONTENT"));
                reply.setReply_date(rs.getDate("REPLY_DATE"));
                reply.setMember_nickname(rs.getString("NICKNAME"));

				replyList.add(reply);
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return replyList;
	}

	// 게시글에 대한 댓글 가져오기
	public List<Reply> getReplyByPostId(int postId) {
		List<Reply> replyList = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

			String sql = "SELECT R.*, M.NICKNAME FROM REPLY R " +
                    "JOIN MEMBER M ON R.MEMBER_ID = M.MEMBER_ID " +
                    "WHERE R.POST_ID = ? ORDER BY R.REPLY_DATE DESC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Reply reply = new Reply();
				
				reply.setReply_id(rs.getInt("REPLY_ID"));
                reply.setMember_id(rs.getInt("MEMBER_ID"));
                reply.setLandmark_id(rs.getInt("LANDMARK_ID"));
                reply.setPost_id(rs.getInt("POST_ID"));
                reply.setReply_content(rs.getString("REPLY_CONTENT"));
                reply.setReply_date(rs.getDate("REPLY_DATE"));
                reply.setMember_nickname(rs.getString("NICKNAME"));

				replyList.add(reply);
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return replyList;
	}

	// 기존 호환성을 위한 메서드 (reference_id 사용)
	public List<Reply> getReplyContent(int referenceId) {
		List<Reply> replyList = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

			String sql = "SELECT R.*, M.NICKNAME FROM REPLY R " +
                    "JOIN MEMBER M ON R.MEMBER_ID = M.MEMBER_ID " +
                    "WHERE R.REFERENCE_ID = ? ORDER BY R.REPLY_DATE DESC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, referenceId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Reply reply = new Reply();
				
				reply.setReply_id(rs.getInt("REPLY_ID"));
                reply.setMember_id(rs.getInt("MEMBER_ID"));
                reply.setReference_id(rs.getInt("REFERENCE_ID"));
                reply.setLandmark_id(rs.getInt("LANDMARK_ID"));
                reply.setPost_id(rs.getInt("POST_ID"));
                reply.setReply_content(rs.getString("REPLY_CONTENT"));
                reply.setReply_date(rs.getDate("REPLY_DATE"));
                reply.setMember_nickname(rs.getString("NICKNAME"));

				replyList.add(reply);
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return replyList;
	}
	
	// 랜드마크에 댓글 추가
	public boolean addReplyToLandmark(int memberId, int landmarkId, String content) {
        System.out.println("=== addReplyToLandmark 호출됨 ===");
        System.out.println("memberId: " + memberId);
        System.out.println("landmarkId: " + landmarkId);
        System.out.println("content: " + content);
        
        String sql = "INSERT INTO REPLY (REPLY_ID, MEMBER_ID, LANDMARK_ID, REPLY_CONTENT, REPLY_DATE) " +
                     "VALUES (REPLY_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, landmarkId);
            pstmt.setString(3, content);

            System.out.println("SQL 실행 전");
            int result = pstmt.executeUpdate();
            System.out.println("SQL 실행 결과: " + result);
            return result > 0;

        } catch (Exception e) {
            System.out.println("addReplyToLandmark 오류: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

	// 게시글에 댓글 추가
	public boolean addReplyToPost(int memberId, int postId, String content) {
        String sql = "INSERT INTO REPLY (REPLY_ID, MEMBER_ID, POST_ID, REPLY_CONTENT, REPLY_DATE) " +
                     "VALUES (REPLY_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, postId);
            pstmt.setString(3, content);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

	// 기존 호환성을 위한 메서드 (reference_id 사용)
	public boolean addReply(int memberId, int referenceId, String content) {
        String sql = "INSERT INTO REPLY (REPLY_ID, MEMBER_ID, REFERENCE_ID, REPLY_CONTENT, REPLY_DATE) " +
                     "VALUES (REPLY_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, referenceId);
            pstmt.setString(3, content);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
	// 회원이 작성한 댓글 가져오기
	public List<Reply> getRepliesByMemberId(int memberId) {
	    List<Reply> replyList = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        Class.forName("oracle.jdbc.driver.OracleDriver");
	        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	        String sql = "SELECT R.*, M.NICKNAME FROM REPLY R " +
	                     "JOIN MEMBER M ON R.MEMBER_ID = M.MEMBER_ID " +
	                     "WHERE R.MEMBER_ID = ? ORDER BY R.REPLY_DATE DESC";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, memberId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Reply reply = new Reply();
	            reply.setReply_id(rs.getInt("REPLY_ID"));
	            reply.setMember_id(rs.getInt("MEMBER_ID"));
	            reply.setLandmark_id(rs.getInt("LANDMARK_ID"));
	            reply.setPost_id(rs.getInt("POST_ID"));
	            reply.setReply_content(rs.getString("REPLY_CONTENT"));
	            reply.setReply_date(rs.getDate("REPLY_DATE"));
	            reply.setMember_nickname(rs.getString("NICKNAME"));
	            replyList.add(reply);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return replyList;
	}

}