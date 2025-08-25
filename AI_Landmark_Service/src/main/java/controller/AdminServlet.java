package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.SuggestionDAO;

@WebServlet("/admin") // 관리자 페이지 주소
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. 로그인 상태 및 'ADMIN' 역할인지 확인합니다.
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            // 관리자가 아니면 메인 페이지로 보내거나, 접근 거부 페이지를 보여줍니다.
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }

        // 2. DAO를 통해 대기 중인 제안 목록을 가져옵니다.
        SuggestionDAO dao = new SuggestionDAO();
        List<Map<String, Object>> pendingSuggestions = dao.getPendingSuggestions();

        // 3. 가져온 목록을 request에 담아 JSP로 전달합니다.
        request.setAttribute("suggestions", pendingSuggestions);
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }
}
