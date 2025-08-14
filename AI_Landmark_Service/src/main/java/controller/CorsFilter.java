package controller;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;


@WebFilter("/*") // 모든 요청("/*")에 대해 이 필터를 적용합니다.
public class CorsFilter implements Filter {

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
    	
    	System.out.println("====== CORS 필터 실행됨! ======"); 
        HttpServletResponse response = (HttpServletResponse) res;
        
        // 여기에 프론트엔드 서버의 주소를 정확히 적어주세요.
        response.setHeader("Access-Control-Allow-Origin", "http://127.0.0.1:5500");

        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE, PUT");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With, remember-me");

//        // 프리플라이트 요청일 경우 바로 200 응답 후 종료
//        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
//            response.setStatus(HttpServletResponse.SC_OK);
//            return;
//        }
        
        
        chain.doFilter(req, res);
    }

	public void init(FilterConfig filterConfig) {
	}

	public void destroy() {
	}
}