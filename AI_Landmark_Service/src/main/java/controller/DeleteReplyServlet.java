package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ReplyDAO; // ReplyDAO와 Reply 모델이 있다고 가정합니다.
import model.Reply; // 최신 Reply 모델을 사용합니다.

@WebServlet("/deleteReply") // 이 어노테이션을 통해 /deleteReply URL로 매핑됩니다.
public class DeleteReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Object loginMemberObj = session.getAttribute("memberId");

        // 1. 로그인 여부 확인
        if (loginMemberObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            response.getWriter().write("로그인이 필요합니다.");
            return;
        }

        int loginMemberId;
        try {
            // 세션의 memberId를 String으로 변환 후 int로 파싱 (안전한 타입 변환)
            // session.setAttribute("memberId", someIntValue); 로 저장되었더라도 Object 타입으로 반환될 수 있으므로
            // toString()을 통해 String으로 만들고 다시 parseInt()로 변환하는 것이 가장 안전합니다.
            loginMemberId = Integer.parseInt(loginMemberObj.toString());
        } catch (NumberFormatException e) {
            // String이 숫자로 변환될 수 없거나 loginMemberObj.toString()이 null인 경우
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            response.getWriter().write("사용자 ID 정보를 읽는 데 실패했습니다. 유효하지 않은 형식입니다.");
            System.err.println("세션의 memberId를 int로 변환 중 오류 발생: " + e.getMessage());
            return;
        } catch (Exception e) { // 기타 예외 처리 (예: NullPointerException 등)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            response.getWriter().write("사용자 ID 정보를 읽는 데 알 수 없는 오류가 발생했습니다.");
            System.err.println("세션의 memberId 처리 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            return;
        }


        // 2. 삭제할 댓글 ID 가져오기
        String commentIdStr = request.getParameter("commentId");
        if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            response.getWriter().write("삭제할 댓글 ID가 필요합니다.");
            return;
        }

        int commentId;
        try {
            commentId = Integer.parseInt(commentIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            response.getWriter().write("유효하지 않은 댓글 ID 형식입니다.");
            return;
        }

        ReplyDAO replyDAO = new ReplyDAO();
        try {
            // 3. 댓글 정보 조회 (댓글 작성자의 memberId 포함)
            // 이 메서드는 댓글 ID를 통해 해당 댓글 객체를 반환해야 합니다.
            // Reply 모델에 getMember_id() 메서드가 있다고 가정하며,
            // 이 메서드는 데이터베이스의 MEMBER_ID 컬럼 값을 가져옵니다.
            Reply replyToDelete = replyDAO.getReplyByReplyId(commentId); 

            if (replyToDelete == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404 Not Found (댓글이 존재하지 않음)
                response.getWriter().write("삭제할 댓글을 찾을 수 없습니다.");
                return;
            }

            // 4. 권한 검증: 로그인한 사용자와 댓글 작성자가 동일한지 확인
            // Reply 모델의 getMember_id() 메서드를 사용하여 비교합니다.
            if (loginMemberId == replyToDelete.getMember_id()) { // <-- 이 부분을 수정했습니다.
                // 5. 권한 검증 성공: 댓글 삭제 실행
                boolean deleted = replyDAO.deleteReply(commentId);
                if (deleted) {
                    response.setStatus(HttpServletResponse.SC_OK); // 200 OK
                    response.getWriter().write("댓글이 성공적으로 삭제되었습니다.");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
                    response.getWriter().write("댓글 삭제 중 오류가 발생했습니다.");
                }
            } else {
                // 6. 권한 검증 실패: 접근 금지 응답
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
                response.getWriter().write("이 댓글을 삭제할 권한이 없습니다.");
            }

        } catch (Exception e) {
            // 데이터베이스 오류, DAO 메서드 호출 중 예외 등 일반적인 서버 오류 처리
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            response.getWriter().write("서버 오류가 발생했습니다: " + e.getMessage());
            System.err.println("댓글 삭제 서블릿 오류: " + e.getMessage());
            e.printStackTrace();
        }
    }
}