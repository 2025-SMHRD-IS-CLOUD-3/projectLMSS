package controller;

import dao.PostDAO;
import model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/postList")
public class PostListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("✅ PostListServlet 실행됨");  // 서블릿 실행 여부 확인용 로그

        // 검색 키워드 파라미터 받기
        String keyword = request.getParameter("keyword");
        System.out.println("검색 키워드: " + keyword);

        PostDAO postDAO = new PostDAO();
        List<Post> postList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // 검색어가 있으면 검색 결과 가져오기
            postList = postDAO.searchPosts(keyword.trim());
            System.out.println("✅ 검색 결과 게시글 개수: " + postList.size());
        } else {
            // 검색어가 없으면 전체 게시글 가져오기
            postList = postDAO.getAllPosts();
            System.out.println("✅ 전체 게시글 개수: " + postList.size());
        }

        // postList JSP에 전달
        request.setAttribute("postList", postList);
        request.setAttribute("keyword", keyword); // 검색어도 함께 전달

        // postList.jsp로 forward
        request.getRequestDispatcher("postList.jsp").forward(request, response);
    }
}
