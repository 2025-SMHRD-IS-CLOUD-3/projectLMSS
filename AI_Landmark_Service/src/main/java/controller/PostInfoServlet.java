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

        String idParam = request.getParameter("postId");

        // null 또는 빈 문자열 방어
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("postList");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("postList");
            return;
        }

        Post post = postDAO.getPostById(postId);

        if (post == null) {
            response.sendRedirect("postList");
            return;
        }

        request.setAttribute("post", post);

        // 실제 JSP 이름과 대소문자 맞추기!
        request.getRequestDispatcher("/postInfo.jsp").forward(request, response);
    }
}
