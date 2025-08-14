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
                landmark.setLandmark_id(rs.getInt("LANDMARK_ID"));
                landmark.setLandmark_name(rs.getString("LANDMARK_NAME"));
                landmark.setLandmark_location(rs.getString("LANDMARK_LOCATION"));
                landmark.setLandmark_desc(rs.getString("LANDMARK_DESC"));
                landmark.setArch_style(rs.getString("ARCH_STYLE"));
                landmark.setFee(rs.getString("FEE"));
                landmark.setArchitect(rs.getString("ARCHITECT"));
                landmark.setTmi(rs.getString("TMI"));
                landmark.setWebsite(rs.getString("WEBSITE"));
                landmark.setLandmark_usage(rs.getString("LANDMARK_USAGE"));
                landmark.setLandmark_hours(rs.getString("LANDMARK_HOURS"));
                landmark.setTraffic_info(rs.getString("TRAFFIC_INFO"));
                landmark.setCompletion_time(rs.getString("COMPLETION_TIME"));
                landmark.setLongitude(rs.getString("LONGITUDE"));
                landmark.setLatitude(rs.getString("LATITUDE"));
                landmark.setLandmark_name_en(rs.getString("LANDMARK_NAME_EN"));
                
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
    	
    public Landmark getLandmarkByName(String landmarkNameEn) {
        // AI 모델이 반환하는 이름(Eiffel_Tower)과 DB에 저장된 이름이 다를 경우를 대비해,
        // 언더스코어(_)를 공백으로 치환합니다. (예: Eiffel Tower)
        String searchName = landmarkNameEn.replace('_', ' ');
        
        String sql = "SELECT * FROM LANDMARK WHERE LANDMARK_NAME_EN = ?"; // 영문 이름 컬럼으로 조회
        Landmark landmark = null;
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, searchName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                landmark = new Landmark();
                landmark.setLandmark_id(rs.getInt("LANDMARK_ID"));
                landmark.setLandmark_name(rs.getString("LANDMARK_NAME"));
                landmark.setLandmark_location(rs.getString("LANDMARK_LOCATION"));
                landmark.setLandmark_desc(rs.getString("LANDMARK_DESC"));
                landmark.setArch_style(rs.getString("ARCH_STYLE"));
                landmark.setFee(rs.getString("FEE"));
                landmark.setArchitect(rs.getString("ARCHITECT"));
                landmark.setTmi(rs.getString("TMI"));
                landmark.setWebsite(rs.getString("WEBSITE"));
                landmark.setLandmark_usage(rs.getString("LANDMARK_USAGE"));
                landmark.setLandmark_hours(rs.getString("LANDMARK_HOURS"));
                landmark.setTraffic_info(rs.getString("TRAFFIC_INFO"));
                landmark.setCompletion_time(rs.getString("COMPLETION_TIME"));
                landmark.setLongitude(rs.getString("LONGITUDE"));
                landmark.setLatitude(rs.getString("LATITUDE"));
                landmark.setLandmark_name_en(rs.getString("LANDMARK_NAME_EN"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return landmark;
    }
    
    public Landmark getLandmarkByNameEn(String landmarkNameEn) {
        String sql = "SELECT * FROM LANDMARK WHERE LANDMARK_NAME_EN = ?";
        Landmark landmark = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, landmarkNameEn);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                landmark = new Landmark();
                landmark.setLandmark_id(rs.getInt("LANDMARK_ID"));
                landmark.setLandmark_name(rs.getString("LANDMARK_NAME"));
                landmark.setLandmark_location(rs.getString("LANDMARK_LOCATION"));
                landmark.setLandmark_desc(rs.getString("LANDMARK_DESC"));
                landmark.setArch_style(rs.getString("ARCH_STYLE"));
                landmark.setFee(rs.getString("FEE"));
                landmark.setArchitect(rs.getString("ARCHITECT"));
                landmark.setTmi(rs.getString("TMI"));
                landmark.setWebsite(rs.getString("WEBSITE"));
                landmark.setLandmark_usage(rs.getString("LANDMARK_USAGE"));
                landmark.setLandmark_hours(rs.getString("LANDMARK_HOURS"));
                landmark.setTraffic_info(rs.getString("TRAFFIC_INFO"));
                landmark.setCompletion_time(rs.getString("COMPLETION_TIME"));
                landmark.setLongitude(rs.getString("LONGITUDE"));
                landmark.setLatitude(rs.getString("LATITUDE"));
                landmark.setLandmark_name_en(rs.getString("LANDMARK_NAME_EN"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return landmark;
    }
    
}