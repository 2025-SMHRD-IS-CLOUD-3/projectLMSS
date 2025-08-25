package controller;

import dao.PostDAO;
import model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/postWrite")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class PostWriteServlet extends HttpServlet {

    // 👇 [추가] 이미지를 저장할 외부 폴더 경로를 지정합니다.
    // ❗ 이 폴더는 미리 만들어 두어야 합니다. (예: C 드라이브에 uploads 폴더 생성)
    // ❗ 팀원과 이 경로를 통일하거나, 각자 자신의 경로로 설정해야 합니다.
    private static final String UPLOAD_DIRECTORY = "C:/landmark_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=postWrite");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=postWrite");
            return;
        }
        
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String content = request.getParameter("content");
        
        // ... (기존의 필수값 검증 로직은 동일) ...

        Post post = new Post();
        post.setTitle(title.trim());
        post.setCategories(category.trim());
        post.setPostContent(content.trim());
        
        Integer memberId = (Integer) session.getAttribute("memberId");
        if (memberId == null) {
            // ... (에러 처리) ...
            return;
        }
        post.setMemberId(memberId);
        
        // 👇 [수정] 이미지 파일 처리 로직
        Part filePart = request.getPart("postImage");
        String fileName = filePart.getSubmittedFileName();
        
        if (fileName != null && !fileName.isEmpty()) {
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            filePart.write(UPLOAD_DIRECTORY + File.separator + fileName);
            
            // 👇 [수정] DB에는 이제 순수한 파일 이름만 저장합니다.
            post.setPostImageUrl(fileName);
        }

        // DB 저장
        PostDAO postDAO = new PostDAO();
        int result = postDAO.insertPost(post);
        
        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/postList");
        } else {
            request.setAttribute("error", "게시글 작성에 실패했습니다.");
            request.getRequestDispatcher("/WEB-INF/postWrite.jsp").forward(request, response);
        }
    }
}
