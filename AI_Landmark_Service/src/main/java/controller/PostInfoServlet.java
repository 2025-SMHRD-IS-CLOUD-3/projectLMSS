package controller;

import dao.PostDAO;
import model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/postInfo")
public class PostInfoServlet extends HttpServlet {
    private PostDAO postDAO;

    @Override
    public void init() {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ PostInfoServlet 실행됨");

        String idParam = request.getParameter("postId");

        // null 또는 빈 문자열 방어
        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("❌ postId 파라미터가 없음");
            response.sendRedirect("postList");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            System.out.println("❌ postId 파라미터가 숫자가 아님: " + idParam);
            response.sendRedirect("postList");
            return;
        }

        System.out.println("조회할 게시글 ID: " + postId);

        Post post = postDAO.getPostById(postId);

        if (post == null) {
            System.out.println("❌ 게시글을 찾을 수 없음: " + postId);
            response.sendRedirect("postList");
            return;
        }

        // 조회수 증가
        postDAO.increaseViews(postId);
        System.out.println("✅ 조회수 증가 완료");

        request.setAttribute("post", post);

        // 실제 JSP 이름과 대소문자 맞추기!
        request.getRequestDispatcher("/postInfo.jsp").forward(request, response);
    }
}
