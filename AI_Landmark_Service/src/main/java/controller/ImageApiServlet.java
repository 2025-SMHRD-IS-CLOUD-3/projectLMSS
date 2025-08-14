package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Objects;

@WebServlet("/api/images")
public class ImageApiServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setHeader("Access-Control-Allow-Origin","*");
    resp.setHeader("Access-Control-Allow-Methods","GET,OPTIONS");
    resp.setContentType("application/json; charset=UTF-8");

    String idStr = req.getParameter("landmarkId"); // 예: ?landmarkId=1
    if (idStr == null) {
      resp.setStatus(400);
      resp.getWriter().write("{\"error\":\"require landmarkId\"}");
      return;
    }

    // 일부 환경에서 필요
    try { Class.forName("oracle.jdbc.OracleDriver"); } catch (Exception ignore) {}

    try (Connection conn = DriverManager.getConnection(
             "jdbc:oracle:thin:@localhost:1521/XEPDB1", "YOUR_SCHEMA", "YOUR_PASSWORD");
         PreparedStatement ps = conn.prepareStatement(
             "SELECT IMAGE_ID, LANDMARK_ID, IMAGE_URL, IMAGE_TYPE " +
             "FROM LANDMARK_IMAGE WHERE LANDMARK_ID=? ORDER BY IMAGE_ID")) {

      ps.setLong(1, Long.parseLong(idStr));
      ResultSet rs = ps.executeQuery();

      StringBuilder json = new StringBuilder("[");
      boolean first = true;
      while (rs.next()) {
        if (!first) json.append(',');
        first = false;
        String imageUrl  = rs.getString("IMAGE_URL");
        String imageType = Objects.toString(rs.getString("IMAGE_TYPE"), "");
        json.append("{\"imageId\":").append(rs.getLong("IMAGE_ID"))
            .append(",\"landmarkId\":").append(rs.getLong("LANDMARK_ID"))
            .append(",\"imageUrl\":\"").append(escape(imageUrl)).append("\"")
            .append(",\"imageType\":\"").append(escape(imageType)).append("\"}");
      }
      json.append("]");
      resp.getWriter().write(json.toString());

    } catch (Exception e) {
      resp.setStatus(500);
      resp.getWriter().write("{\"error\":\"db_error\",\"message\":\""+escape(e.getMessage())+"\"}");
    }
  }

  private static String escape(String s) {
    if (s == null) return "";
    return s.replace("\\","\\\\").replace("\"","\\\"");
  }
}
