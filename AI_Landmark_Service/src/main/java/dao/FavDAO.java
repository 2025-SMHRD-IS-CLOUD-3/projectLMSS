package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Favorite;

public class FavDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2";

    /**
     * 특정 회원의 즐겨찾기 목록 전체를 랜드마크 정보와 함께 조회합니다.
     * @param memberId 회원 ID
     * @return 즐겨찾기 목록 (List<Favorite>)
     */
    public List<Favorite> getFavoritesByMemberId(int memberId) {
        List<Favorite> favoriteList = new ArrayList<>();
        // FAVORITES 테이블과 LANDMARK 테이블을 JOIN하여 필요한 정보를 가져옵니다.
        String sql = "SELECT F.FAVORITES_ID, F.MEMBER_ID, F.LANDMARK_ID, L.LANDMARK_NAME, L.LANDMARK_LOCATION, L.LANDMARK_NAME_EN " +
                     "FROM FAVORITES F " +
                     "JOIN LANDMARK L ON F.LANDMARK_ID = L.LANDMARK_ID " +
                     "WHERE F.MEMBER_ID = ? " +
                     "ORDER BY F.FAVORITES_ID DESC";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Favorite fav = new Favorite();
                    fav.setFavorites_id(rs.getInt("FAVORITES_ID"));
                    fav.setMember_id(rs.getInt("MEMBER_ID"));
                    fav.setLandmark_id(rs.getInt("LANDMARK_ID"));
                    fav.setLandmark_name(rs.getString("LANDMARK_NAME"));
                    fav.setLandmark_location(rs.getString("LANDMARK_LOCATION"));
                    fav.setLandmark_name_en(rs.getString("LANDMARK_NAME_EN"));
                    favoriteList.add(fav);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return favoriteList;
    }

    /**
     * 즐겨찾기를 추가합니다.
     * @param memberId 회원 ID
     * @param landmarkId 랜드마크 ID
     * @return 성공 시 true, 실패 시 false
     */
    public boolean addFavorite(int memberId, int landmarkId) {
        String sql = "INSERT INTO FAVORITES (FAVORITES_ID, MEMBER_ID, LANDMARK_ID) VALUES (FAVORITES_SEQ.NEXTVAL, ?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, landmarkId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 즐겨찾기를 삭제합니다.
     * @param memberId 회원 ID
     * @param landmarkId 랜드마크 ID
     * @return 성공 시 true, 실패 시 false
     */
    public boolean removeFavorite(int memberId, int landmarkId) {
        String sql = "DELETE FROM FAVORITES WHERE MEMBER_ID = ? AND LANDMARK_ID = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, landmarkId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 특정 회원이 특정 랜드마크를 즐겨찾기 했는지 확인합니다.
     * @param memberId 회원 ID
     * @param landmarkId 랜드마크 ID
     * @return 즐겨찾기 상태이면 true, 아니면 false
     */
    public boolean isFavorited(int memberId, int landmarkId) {
        String sql = "SELECT COUNT(*) FROM FAVORITES WHERE MEMBER_ID = ? AND LANDMARK_ID = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, landmarkId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
