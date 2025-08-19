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

	            String sql = "SELECT * FROM LANDMARK_IMAGE";
	            pstmt = conn.prepareStatement(sql);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	Hotspot hotspot = new Hotspot();
	                hotspot.setHotspot_id(rs.getInt("HOTSPOT_ID"));
	                hotspot.setHotspot_info(rs.getString("HOTSPOT_INFO"));
	                hotspot.setHotspot_type(rs.getString("HOTSPOT_INFO"));
	                hotspot.setHotspot_long(rs.getDouble("HOTSPOT_LONG"));
	                hotspot.setHotspot_lati(rs.getDouble("HOTSPOT_LATI"));
	                hotspot.setHotspot_type(rs.getString("HOTSPOT_TYPE"));
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
}
