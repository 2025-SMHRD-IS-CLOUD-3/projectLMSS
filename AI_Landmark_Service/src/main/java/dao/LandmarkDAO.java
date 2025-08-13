package dao;

import model.Landmark; // Landmark.java 클래스를 사용하기 위해 import
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LandmarkDAO {
    private static final String DB_URL = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe";
    private static final String DB_USER = "campus_24IS_CLOUD3_p2_2";
    private static final String DB_PASSWORD = "smhrd2"; // 본인의 비밀번호로 수정

    public List<Landmark> getAllLandmarks() {
        List<Landmark> landmarkList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM LANDMARK";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Landmark landmark = new Landmark();
                landmark.setLandmarkId(rs.getInt("LANDMARK_ID"));
                landmark.setLandmarkName(rs.getString("LANDMARK_NAME"));
                landmark.setLocation(rs.getString("LOCATION"));
                landmark.setDescription(rs.getString("DESCRIPTION"));
                landmarkList.add(landmark);
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
        return landmarkList;
    }
}