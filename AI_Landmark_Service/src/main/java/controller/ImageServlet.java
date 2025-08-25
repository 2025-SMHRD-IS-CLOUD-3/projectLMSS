package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/image") // ❗ 이 서블릿의 주소는 /image 입니다.
public class ImageServlet extends HttpServlet {

    // ❗ PostWriteServlet에 있는 경로와 반드시 동일해야 합니다.
    private static final String UPLOAD_DIRECTORY = "C:/landmark_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. URL에서 배달할 파일 이름을 가져옵니다. (예: /image?name=eiffel.jpg)
        String fileName = request.getParameter("name");
        
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File name is required.");
            return;
        }

        // 2. 실제 파일 경로를 만듭니다.
        File file = new File(UPLOAD_DIRECTORY, fileName);

        // 3. 파일이 실제로 존재하는지 확인합니다.
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found.");
            return;
        }

        // 4. 브라우저에게 "이것은 이미지 파일입니다" 라고 알려줍니다.
        String mimeType = getServletContext().getMimeType(file.getAbsolutePath());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLength((int) file.length());

        // 5. 파일을 읽어서 브라우저에게 직접 전송(배달)합니다.
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead = -1;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
