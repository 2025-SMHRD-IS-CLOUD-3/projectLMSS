package controller;

import dao.PostDAO;
import model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/postWrite")
public class PostWriteServlet extends HttpServlet {

    // ✅ GET 요청: 글쓰기 폼 진입
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 로그인 안 된 경우 → 로그인 후 돌아올 URL 저장
            session.setAttribute("redirectURL", request.getContextPath() + "/postWrite");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 로그인 되어 있음 → 글쓰기 JSP 열기 (WEB-INF 경로)
        request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
    }

    // ✅ POST 요청: 글 작성 처리
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 🔹 기존 세션을 유지하도록 수정
        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 로그인 세션이 없으면 로그인 페이지로
            session.setAttribute("redirectURL", request.getContextPath() + "/postWrite");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ 폼 데이터 받기
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String content = request.getParameter("content");

        // ✅ Post 객체 생성
        Post post = new Post();
        post.setTitle(title);
        post.setCategories(category);
        post.setPostContent(content);

        // ✅ 로그인된 사용자 ID 가져오기
        Integer memberId = (Integer) session.getAttribute("memberId");
        if (memberId == null) {
            memberId = 0; // 안전장치 (실제론 로그인 시 꼭 넣어줘야 함)
        }
        post.setMemberId(memberId);

        // ✅ DB 저장
        PostDAO postDAO = new PostDAO();
        int result = postDAO.insertPost(post);

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/postList");
        } else {
            response.sendRedirect(request.getContextPath() + "/postWrite?error=1");
        }
    }
}
