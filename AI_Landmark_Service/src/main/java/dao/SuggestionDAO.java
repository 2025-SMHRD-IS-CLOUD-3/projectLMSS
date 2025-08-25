// dao/SuggestionDAO.java
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SuggestionDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2";

    /**
     * 사용자의 핫스팟 제안을 DB에 추가합니다.
     * @return 성공 시 true, 실패 시 false
     */
    public boolean addSuggestion(int memberId, int landmarkId, String hotspotType, String hotspotName, String hotspotInfo, double latitude, double longitude) {
        String sql = "INSERT INTO HOTSPOT_SUGGESTIONS " +
                     "(SUGGESTION_ID, MEMBER_ID, LANDMARK_ID, HOTSPOT_TYPE, HOTSPOT_NAME, HOTSPOT_INFO, HOTSPOT_LATI, HOTSPOT_LONG) " +
                     "VALUES (SUGGESTION_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, memberId);
    
            pstmt.setInt(2, landmarkId);
            pstmt.setString(3, hotspotType);
            pstmt.setString(4, hotspotName);
            pstmt.setString(5, hotspotInfo);
            pstmt.setDouble(6, latitude);
            pstmt.setDouble(7, longitude);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 처리 대기 중인 모든 핫스팟 제안 목록을 가져옵니다.
     * @return 대기 중인 제안 목록 (List<Map<String, Object>>)
     */
    public List<Map<String, Object>> getPendingSuggestions() {
        List<Map<String, Object>> suggestionList = new ArrayList<>();
        // SUGGESTIONS 테이블과 MEMBER, LANDMARK 테이블을 JOIN하여 필요한 정보를 모두 가져옵니다.
        String sql = "SELECT S.*, M.NICKNAME, L.LANDMARK_NAME " +
                     "FROM HOTSPOT_SUGGESTIONS S " +
                     "JOIN MEMBER M ON S.MEMBER_ID = M.MEMBER_ID " +
                     "JOIN LANDMARK L ON S.LANDMARK_ID = L.LANDMARK_ID " +
                     "WHERE S.STATUS = 'pending' " +
                     "ORDER BY S.SUGGESTED_AT ASC"; // 오래된 제안부터 보이도록 정렬
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            while (rs.next()) {
                Map<String, Object> suggestion = new HashMap<>();
                suggestion.put("suggestion_id", rs.getInt("SUGGESTION_ID"));
                suggestion.put("landmark_name", rs.getString("LANDMARK_NAME"));
                suggestion.put("hotspot_name", rs.getString("HOTSPOT_NAME"));
                suggestion.put("hotspot_type", rs.getString("HOTSPOT_TYPE"));
                suggestion.put("suggester_nickname", rs.getString("NICKNAME"));
                suggestion.put("suggested_at", rs.getDate("SUGGESTED_AT"));
                suggestionList.add(suggestion);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return suggestionList;
    }

    /**
     * 특정 제안 ID에 해당하는 상세 정보를 가져옵니다. (승인 시 필요)
     * @param suggestionId 제안 ID
     * @return 제안 정보가 담긴 Map
     */
    public Map<String, Object> getSuggestionById(int suggestionId) {
        Map<String, Object> suggestion = null;
        String sql = "SELECT * FROM HOTSPOT_SUGGESTIONS WHERE SUGGESTION_ID = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setInt(1, suggestionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    suggestion = new HashMap<>();
                    suggestion.put("LANDMARK_ID", rs.getInt("LANDMARK_ID"));
                    suggestion.put("HOTSPOT_TYPE", rs.getString("HOTSPOT_TYPE"));
                    suggestion.put("HOTSPOT_NAME", rs.getString("HOTSPOT_NAME"));
                    suggestion.put("HOTSPOT_INFO", rs.getString("HOTSPOT_INFO"));
                    suggestion.put("HOTSPOT_LATI", rs.getDouble("HOTSPOT_LATI"));
                    suggestion.put("HOTSPOT_LONG", rs.getDouble("HOTSPOT_LONG"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return suggestion;
    }

    /**
     * 제안의 상태(status)를 변경합니다. (승인/거절 시 필요)
     * @param suggestionId 제안 ID
     * @param status 변경할 상태 ("approved" 또는 "rejected")
     * @return 성공 시 true, 실패 시 false
     */
    public boolean updateSuggestionStatus(int suggestionId, String status) {
        String sql = "UPDATE HOTSPOT_SUGGESTIONS SET STATUS = ? WHERE SUGGESTION_ID = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            pstmt.setString(1, status);
            pstmt.setInt(2, suggestionId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
