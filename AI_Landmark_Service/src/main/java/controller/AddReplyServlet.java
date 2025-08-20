package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ReplyDAO;

@WebServlet("/addReply")
public class AddReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== AddReplyServlet 호출됨 ===");
        
        request.setCharacterEncoding("UTF-8");
        
        // 로그인 체크
        HttpSession session = request.getSession();
        Object memberIdObj = session.getAttribute("memberId");
        
        System.out.println("memberIdObj: " + memberIdObj);
        
        if (memberIdObj == null) {
            System.out.println("로그인되지 않은 사용자");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("로그인이 필요합니다.");
            return;
        }
        
        int memberId = Integer.parseInt(memberIdObj.toString());
        String content = request.getParameter("commentText");
        String replyType = request.getParameter("replyType");
        String referenceIdStr = request.getParameter("referenceId");
        
        System.out.println("memberId: " + memberId);
        System.out.println("content: " + content);
        System.out.println("replyType: " + replyType);
        System.out.println("referenceIdStr: " + referenceIdStr);
        
        if (content == null || content.trim().isEmpty()) {
            System.out.println("댓글 내용이 비어있음");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("댓글 내용을 입력해주세요.");
            return;
        }
        
        // 댓글 타입 확인 (landmark 또는 post)
        if (referenceIdStr == null || referenceIdStr.trim().isEmpty()) {
            System.out.println("참조 ID가 비어있음");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("참조 ID가 필요합니다.");
            return;
        }
        
        int referenceId = Integer.parseInt(referenceIdStr);
        ReplyDAO replyDAO = new ReplyDAO();
        boolean success = false;
        
        System.out.println("referenceId: " + referenceId);
        System.out.println("replyType: " + replyType);
        
        try {
            if ("landmark".equals(replyType)) {
                System.out.println("랜드마크 댓글 추가 시도");
                // 랜드마크에 댓글 추가
                success = replyDAO.addReplyToLandmark(memberId, referenceId, content);
            } else if ("post".equals(replyType)) {
                System.out.println("게시글 댓글 추가 시도");
                // 게시글에 댓글 추가
                success = replyDAO.addReplyToPost(memberId, referenceId, content);
            } else {
                System.out.println("기본 랜드마크 댓글 추가 시도");
                // 기본값으로 랜드마크로 처리 (기존 호환성)
                success = replyDAO.addReplyToLandmark(memberId, referenceId, content);
            }
            
            System.out.println("댓글 추가 결과: " + success);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("댓글이 성공적으로 추가되었습니다.");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("댓글 추가에 실패했습니다.");
            }
            
        } catch (Exception e) {
            System.out.println("댓글 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("서버 오류가 발생했습니다.");
        }
    }
}
