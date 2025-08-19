package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.HotspotDAO;
import model.Hotspot;

@WebServlet("/getHotspots")
public class GetHotspotServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HotspotDAO dao = new HotspotDAO();
        List<Hotspot> hotspotList = dao.getHotspotInfo();

        // Gson 라이브러리를 사용해 List를 JSON 배열 문자열로 변환
        String json = new Gson().toJson(hotspotList);

        // 프론트엔드에 응답 설정
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}
