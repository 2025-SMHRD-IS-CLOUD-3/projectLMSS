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

        PostDAO postDAO = new PostDAO();
        List<Post> postList = postDAO.getAllPosts();

        // 불러온 게시글 개수 로그 출력
        System.out.println("✅ 불러온 게시글 개수: " + postList.size());

        // postList JSP에 전달
        request.setAttribute("postList", postList);

        // postList.jsp로 forward
        request.getRequestDispatcher("postList.jsp").forward(request, response);
    }
}
