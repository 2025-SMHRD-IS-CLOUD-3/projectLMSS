package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Hotspot;

public class HotspotDAO {
		private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
	    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
	    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

	    public List<Hotspot> getHotspotInfo() {
	        List<Hotspot> hotspotList = new ArrayList<>();
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	            String sql = "SELECT * FROM HOTSPOT";
	            pstmt = conn.prepareStatement(sql);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	Hotspot hotspot = new Hotspot();
	                hotspot.setHotspot_id(rs.getInt("HOTSPOT_ID"));
	                hotspot.setHotspot_info(rs.getString("HOTSPOT_INFO"));
	                hotspot.setHotspot_long(rs.getDouble("HOTSPOT_LONG"));
	                hotspot.setHotspot_lati(rs.getDouble("HOTSPOT_LATI"));
	                hotspot.setHotspot_type(rs.getString("HOTSPOT_TYPE"));
	                hotspot.setHotspot_name(rs.getString("HOTSPOT_NAME"));
	                
	                hotspotList.add(hotspot);
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
	        return hotspotList;
	    }
	    public boolean addHotspot(int landmarkId, String hotspotType, String hotspotName, String hotspotInfo, double latitude, double longitude) {
	        String sql = "INSERT INTO HOTSPOT " +
	                     "(HOTSPOT_ID, LANDMARK_ID, HOTSPOT_TYPE, HOTSPOT_NAME, HOTSPOT_INFO, HOTSPOT_LATI, HOTSPOT_LONG) " +
	                     "VALUES (HOTSPOT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";
	        
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        boolean success = false;

	        try {
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	            // 👇 [추가] 수동으로 트랜잭션을 관리하기 위해 auto-commit을 끕니다.
	            conn.setAutoCommit(false); 
	            
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, landmarkId);
	            pstmt.setString(2, hotspotType);
	            pstmt.setString(3, hotspotName);
	            pstmt.setString(4, hotspotInfo);
	            pstmt.setDouble(5, latitude);
	            pstmt.setDouble(6, longitude);

	            int result = pstmt.executeUpdate();
	            if (result > 0) {
	                conn.commit(); // 👇 [추가] 변경사항을 DB에 최종 확정합니다.
	                success = true;
	            } else {
	                conn.rollback(); // 실패 시 원상 복구
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	            // 오류 발생 시 롤백
	            if (conn != null) {
	                try {
	                    conn.rollback();
	                } catch (SQLException ex) {
	                    ex.printStackTrace();
	                }
	            }
	        } finally {
	            // 자원 해제
	            try {
	                if (pstmt != null) pstmt.close();
	                if (conn != null) conn.close();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }
	        return success;
	    }
	    
}
