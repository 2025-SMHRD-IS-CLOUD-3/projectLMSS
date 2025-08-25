// controller/SubmitSuggestionServlet.java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.SuggestionDAO;

@WebServlet("/submitSuggestion")
public class SubmitSuggestionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("--- SubmitSuggestionServlet 호출됨 ---");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. 로그인 상태인지 먼저 확인
        if (session == null || session.getAttribute("memberId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요한 기능입니다.");
            return;
        }

        // 2. 폼에서 전송된 모든 데이터를 받습니다.
        String landmarkIdStr = request.getParameter("landmarkId");
        String hotspotType = request.getParameter("hotspotType");
        String hotspotName = request.getParameter("hotspotName");
        String hotspotInfo = request.getParameter("hotspotInfo");
        String latitudeStr = request.getParameter("latitude");
        String longitudeStr = request.getParameter("longitude");

        // 👇 [추가] 어떤 데이터가 들어오는지 이클립스 콘솔에서 확인합니다.
        System.out.println("landmarkId: " + landmarkIdStr);
        System.out.println("hotspotType: " + hotspotType);
        System.out.println("hotspotName: " + hotspotName);
        System.out.println("latitude: " + latitudeStr);
        System.out.println("longitude: " + longitudeStr);

        try {
            // 👇 [수정] 데이터 유효성 검사를 강화합니다.
            if (latitudeStr == null || latitudeStr.trim().isEmpty() || 
                longitudeStr == null || longitudeStr.trim().isEmpty()) {
                throw new IllegalArgumentException("지도에서 위치가 선택되지 않았습니다.");
            }

            int memberId = (int) session.getAttribute("memberId");
            int landmarkId = Integer.parseInt(landmarkIdStr);
            double latitude = Double.parseDouble(latitudeStr);
            double longitude = Double.parseDouble(longitudeStr);
            
            // 3. DAO를 사용해 DB에 제안을 저장합니다.
            SuggestionDAO dao = new SuggestionDAO();
            boolean success = dao.addSuggestion(memberId, landmarkId, hotspotType, hotspotName, hotspotInfo, latitude, longitude);

            // 4. 성공 여부에 따라 응답을 보냅니다.
            if (success) {
                System.out.println("✅ 제안 DB 저장 성공");
                response.sendRedirect(request.getContextPath() + "/landmarkInfo.jsp?id=" + landmarkId + "&msg=suggestion_success");
            } else {
                throw new Exception("DAO에서 제안 추가 실패");
            }

        } catch (Exception e) {
            System.err.println("❌ 제안 처리 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            // 실패 시, 에러 메시지와 함께 이전 페이지로 돌아가도록 처리
            String redirectParams = "?error=true&landmarkId=" + landmarkIdStr;
            response.sendRedirect(request.getContextPath() + "/suggestion.jsp" + redirectParams);
        }
    }
}
