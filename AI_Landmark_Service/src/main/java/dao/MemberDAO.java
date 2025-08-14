package dao;

import model.Member;
import java.sql.*;

public class MemberDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public boolean registerMember(String id, String pwd, String email, String name, String nickname) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = getConnection();
            String sql = "INSERT INTO MEMBER (MEMBER_ID, ID, PWD, EMAIL, NAME, NICKNAME) " +
                         "VALUES (MEMBER_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pwd);
            pstmt.setString(3, email);
            pstmt.setString(4, name);
            pstmt.setString(5, nickname);

            int result = pstmt.executeUpdate();
            if (result > 0) success = true;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return success;
    }

	public Member getMemberById(String memberId) {
		// TODO Auto-generated method stub
		return null;
	}
}
