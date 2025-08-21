// controller/FavoriteServlet.java
package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import dao.FavDAO;

@WebServlet("/favorite") // API 주소: /favorite
public class FavoriteServlet extends HttpServlet {

    /**
     * GET 요청: 현재 랜드마크의 즐겨찾기 상태를 확인합니다.
     * (페이지 로드 시 호출)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. 로그인 상태인지 확인
        if (session == null || session.getAttribute("memberId") == null) {
            // 로그인하지 않았으면, 즐겨찾기 상태가 아님을 응답
            response.getWriter().write("{\"isFavorited\": false}");
            return;
        }

        try {
            // 2. 세션과 요청 파라미터에서 ID 값들을 가져옵니다.
            int memberId = (int) session.getAttribute("memberId");
            int landmarkId = Integer.parseInt(request.getParameter("landmarkId"));

            // 3. FavDAO를 사용해 DB에서 현재 즐겨찾기 상태를 조회합니다.
            FavDAO favDAO = new FavDAO();
            boolean isFavorited = favDAO.isFavorited(memberId, landmarkId);

            // 4. 조회된 상태를 JSON 형태로 프론트엔드에 응답합니다.
            Map<String, Boolean> result = new HashMap<>();
            result.put("isFavorited", isFavorited);
            response.getWriter().write(new Gson().toJson(result));

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Landmark ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error.");
        }
    }

    /**
     * POST 요청: 즐겨찾기 상태를 토글(추가/삭제)합니다.
     * (즐겨찾기 버튼 클릭 시 호출)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. 로그인 상태인지 먼저 확인 (로그인 안 했으면 거부)
        if (session == null || session.getAttribute("memberId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        try {
            // 2. 세션과 요청 파라미터에서 ID 값들을 가져옵니다.
            int memberId = (int) session.getAttribute("memberId");
            int landmarkId = Integer.parseInt(request.getParameter("landmarkId"));

            FavDAO favDAO = new FavDAO();
            boolean isCurrentlyFavorited = favDAO.isFavorited(memberId, landmarkId);
            boolean success;

            // 3. 현재 상태에 따라 추가 또는 삭제 작업을 수행합니다.
            if (isCurrentlyFavorited) {
                // 이미 즐겨찾기 상태 -> 삭제
                success = favDAO.removeFavorite(memberId, landmarkId);
            } else {
                // 즐겨찾기 아닌 상태 -> 추가
                success = favDAO.addFavorite(memberId, landmarkId);
            }

            // 4. 작업 성공 여부와 변경된 후의 최종 상태를 JSON으로 응답합니다.
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            if (success) {
                result.put("isFavorited", !isCurrentlyFavorited); // 상태가 반전되었음을 알림
            }
            response.getWriter().write(new Gson().toJson(result));

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Landmark ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error.");
        }
    }
}
