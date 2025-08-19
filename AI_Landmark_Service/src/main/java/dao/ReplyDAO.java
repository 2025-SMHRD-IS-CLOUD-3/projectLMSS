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
}