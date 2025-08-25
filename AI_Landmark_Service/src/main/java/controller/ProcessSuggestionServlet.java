// controller/ProcessSuggestionServlet.java
package controller;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.HotspotDAO; // ❗ HotspotDAO가 필요합니다.
import dao.SuggestionDAO;

@WebServlet("/processSuggestion")
public class ProcessSuggestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 👇 [추가] 디버깅을 위한 로그
        System.out.println("\n--- ProcessSuggestionServlet 호출됨 ---");
        HttpSession session = request.getSession(false);
        
        // 1. 관리자로 로그인했는지 확인합니다.
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            System.err.println("오류: 관리자 권한이 없습니다.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        try {
            int suggestionId = Integer.parseInt(request.getParameter("suggestionId"));
            String action = request.getParameter("action");
            System.out.println("요청 처리: suggestionId=" + suggestionId + ", action=" + action);

            SuggestionDAO suggestionDAO = new SuggestionDAO();

            if ("approve".equals(action)) {
                System.out.println("-> '승인' 로직 시작");
                // 1. 승인할 제안의 상세 정보를 가져옵니다.
                Map<String, Object> suggestion = suggestionDAO.getSuggestionById(suggestionId);
                
                if (suggestion != null) {
                    System.out.println("-> 제안 정보 조회 성공: " + suggestion);
                    // 2. HotspotDAO를 사용해 실제 HOTSPOT 테이블에 추가합니다.
                    HotspotDAO hotspotDAO = new HotspotDAO();
                    boolean addSuccess = hotspotDAO.addHotspot(
                        (int) suggestion.get("LANDMARK_ID"),
                        (String) suggestion.get("HOTSPOT_TYPE"),
                        (String) suggestion.get("HOTSPOT_NAME"),
                        (String) suggestion.get("HOTSPOT_INFO"),
                        (double) suggestion.get("HOTSPOT_LATI"),
                        (double) suggestion.get("HOTSPOT_LONG")
                    );
                    
                    System.out.println("-> HOTSPOT 테이블 추가 결과: " + addSuccess);
                    
                    if(addSuccess) {
                        // 3. 제안 테이블의 상태를 'approved'로 변경합니다.
                        suggestionDAO.updateSuggestionStatus(suggestionId, "approved");
                        System.out.println("-> 제안 상태 'approved'로 변경 완료");
                    } else {
                        System.err.println("-> 오류: HotspotDAO.addHotspot 메소드가 false를 반환했습니다.");
                    }
                } else {
                    System.err.println("-> 오류: suggestionId " + suggestionId + " 에 해당하는 제안 정보를 찾을 수 없습니다.");
                }
            } else if ("reject".equals(action)) {
                System.out.println("-> '거절' 로직 시작");
                suggestionDAO.updateSuggestionStatus(suggestionId, "rejected");
                System.out.println("-> 제안 상태 'rejected'로 변경 완료");
            }

            // 2. 처리가 끝나면 관리자 페이지로 다시 돌아갑니다.
            response.sendRedirect(request.getContextPath() + "/admin");

        } catch (Exception e) {
            System.err.println("❌ 제안 처리 중 심각한 오류 발생");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?error=true");
        }
    }
}
