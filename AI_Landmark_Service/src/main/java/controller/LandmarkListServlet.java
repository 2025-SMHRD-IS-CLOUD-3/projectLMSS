package controller;

import dao.LandmarkDAO;
import model.Landmark;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AI_Landmark_Service/getLandmark")
public class LandmarkListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LandmarkDAO landmarkDAO = new LandmarkDAO();
        List<Landmark> landmarkList = landmarkDAO.getAllLandmarks();

        request.setAttribute("landmarkList", landmarkList);

        request.getRequestDispatcher("landmarkList.jsp").forward(request, response);
    }
}