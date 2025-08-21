package controller;

import dao.PostDAO;
import model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/postWrite")
public class PostWriteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("✅ PostWriteServlet GET 실행됨");
        
        // 로그인 체크
        HttpSession session = request.getSession();
        if (session.getAttribute("loginUser") == null) {
            // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=postWrite");
            return;
        }
        
        // 로그인된 경우 postWrite.jsp로 포워드
        request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("✅ PostWriteServlet POST 실행됨");
        
        request.setCharacterEncoding("UTF-8");
        
        // 로그인 체크
        HttpSession session = request.getSession();
        if (session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=postWrite");
            return;
        }
        
        // 폼 데이터 받기
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String content = request.getParameter("content");
        
        System.out.println("제목: " + title);
        System.out.println("카테고리: " + category);
        System.out.println("내용: " + content);
        
     // ★ 실패 시 입력값 유지용
        request.setAttribute("formTitle",    title);
        request.setAttribute("formCategory", category);
        request.setAttribute("formContent",  content);
        
     // ★ 필수값 검증: 빠진 항목마다 alertMsg 세팅 후 forward (리다이렉트 X)
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("alertMsg", "제목을 입력하세요.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
            return;
        }
        if (category == null || category.trim().isEmpty()) {
            request.setAttribute("alertMsg", "카테고리를 선택하세요.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
            return;
        }
        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("alertMsg", "내용을 입력하세요.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
            return;
        }
        
        // Post 객체 생성
        Post post = new Post();
        post.setTitle(title.trim());
        post.setCategories(category != null ? category.trim() : "일반");
        post.setPostContent(content.trim());
        
        // 로그인된 사용자 ID 가져오기
        Integer memberId = (Integer) session.getAttribute("memberId");
        if (memberId == null) {
            request.setAttribute("error", "로그인 정보가 올바르지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
            return;
        }
        post.setMemberId(memberId);
        
        // DB 저장
        PostDAO postDAO = new PostDAO();
        int result = postDAO.insertPost(post);
        
        if (result > 0) {
            System.out.println("✅ 게시글 작성 성공");
            response.sendRedirect(request.getContextPath() + "/postList");
        } else {
            System.out.println("❌ 게시글 작성 실패");
            request.setAttribute("error", "게시글 작성에 실패했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
        }
    }
}
