package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dao.LandmarkDAO;
import model.Landmark;

@WebServlet("/getLandmarkDetail")
public class GetLandmarkDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 프론트엔드에서 보낸 'name' 파라미터를 받습니다.
        String landmarkNameEn = request.getParameter("name");

        if (landmarkNameEn == null || landmarkNameEn.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"랜드마크 이름이 필요합니다.\"}");
            return;
        }

        LandmarkDAO dao = new LandmarkDAO();
        Landmark landmark = dao.getLandmarkByNameEn(landmarkNameEn);

        String json = new Gson().toJson(landmark);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}
