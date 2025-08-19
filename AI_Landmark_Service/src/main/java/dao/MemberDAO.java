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

    // 회원 조회
    public Member getMemberById(String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Member member = null;

        try {
            conn = getConnection();
            String sql = "SELECT ID, PWD, EMAIL, NAME, NICKNAME FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setId(rs.getString("ID"));
                member.setPwd(rs.getString("PWD"));
                member.setEmail(rs.getString("EMAIL"));
                member.setName(rs.getString("NAME"));
                member.setNickname(rs.getString("NICKNAME"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return member;
    }

    // 비밀번호 + 이메일 수정
    public int updateMemberPasswordAndEmail(String id, String newPassword, String newEmail) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = getConnection();
            String sql = "UPDATE MEMBER SET PWD=?, EMAIL=? WHERE ID=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, newEmail);
            pstmt.setString(3, id);

            result = pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return result;
    }
}
