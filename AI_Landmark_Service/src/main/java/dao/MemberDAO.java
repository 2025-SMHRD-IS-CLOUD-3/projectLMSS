package dao;

import model.Member; // Member 모델 클래스 import
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

    // 데이터베이스 연결을 얻는 헬퍼 메서드
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // 자원 해제 헬퍼 메서드
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 아이디 중복 확인 메서드
    public boolean isIdDuplicate(String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isDuplicate = false;
        try {
            conn = getConnection();
            String sql = "SELECT COUNT(*) FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                isDuplicate = true; // 중복됨
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return isDuplicate;
    }

    // 닉네임 중복 확인 메서드
    public boolean isNicknameDuplicate(String nickname) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isDuplicate = false;
        try {
            conn = getConnection();
            String sql = "SELECT COUNT(*) FROM MEMBER WHERE NICKNAME = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                isDuplicate = true; // 중복됨
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return isDuplicate;
    }

    // 이메일 중복 확인 메서드
    public boolean isEmailDuplicate(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isDuplicate = false;
        try {
            conn = getConnection();
            String sql = "SELECT COUNT(*) FROM MEMBER WHERE EMAIL = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                isDuplicate = true; // 중복됨
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return isDuplicate;
    }

    // 회원 등록 메서드
    public boolean registerMember(String id, String password, String email, String name, String nickname) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = getConnection();
            String sql = "INSERT INTO MEMBER (MEMBER_ID, ID, PWD, EMAIL, NAME, NICKNAME) VALUES (MEMBER_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, password);
            pstmt.setString(3, email);
            pstmt.setString(4, name);
            pstmt.setString(5, nickname);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true; // 회원가입 성공
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null); // ResultSet는 사용하지 않으므로 null
        }
        return success;
    }

    // 로그인 및 회원 정보 조회를 위해 ID로 Member 객체 조회 (비밀번호 포함)
    public Member getMemberById(String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Member member = null;

        try {
            conn = getConnection();
            // PWD 필드를 함께 조회하여 로그인 검증이나 마이페이지 정보 로딩에 사용
            String sql = "SELECT MEMBER_ID, ID, PWD, EMAIL, NAME, NICKNAME FROM MEMBER WHERE ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setMemberId(rs.getInt("MEMBER_ID"));
                member.setId(rs.getString("ID"));
                member.setPwd(rs.getString("PWD")); // 비밀번호도 가져옴 (로그인 검증에 사용)
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

    // 회원 삭제 (ID와 비밀번호로 확인)
    public boolean deleteMember(String id, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = getConnection();
            // ID와 비밀번호를 확인하여 일치하는 회원 삭제
            String sql = "DELETE FROM MEMBER WHERE ID = ? AND PWD = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, password);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true; // 삭제 성공
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null); // ResultSet는 사용하지 않으므로 null
        }
        return success;
    }
}
