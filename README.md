# 📸 AI Landmark Search
사진 한 장으로 시작하는 스마트한 랜드마크 가이드

여행지에서 마주친 멋진 건축물의 이름이 궁금하신가요?
**AI Landmark Search**는 사용자가 업로드한 사진을 AI로 분석하여 해당 랜드마크의 상세한 정보와 역사, 주변 정보까지 한 번에 제공하는 지능형 여행 정보 플랫폼입니다.

---

## ✨ 주요 기능 (Core Features)
- **AI 이미지 분석**: YOLOv8 기반 딥러닝 모델로 사진을 분석해 랜드마크를 정확히 식별합니다.  
- **상세 정보 제공**: 이름, 역사, 건축 양식, 다각도 이미지, 지도 위치 등 풍부한 정보를 제공합니다.  
- **지도 기반 탐색**: 지도에서 랜드마크 위치와 함께 주변 맛집, 포토 스팟, 명소 정보를 시각적으로 탐색할 수 있습니다.  
- **커뮤니티**: 게시판과 댓글 기능으로 여행 정보를 공유하고 소통할 수 있습니다.  
- **개인화 서비스**: 회원가입/로그인 후 즐겨찾기, 내가 쓴 글과 댓글을 관리할 수 있는 마이페이지 기능을 제공합니다.  

---

## 🏛️ 시스템 아키텍처 (System Architecture)
본 프로젝트는 **Java 메인 서버**와 **Python AI 서버**를 분리한 마이크로서비스 아키텍처로 구성되어 있습니다.

```
[사용자 브라우저] <--> [Java/Tomcat 서버] <--> [Oracle DB]
                      ^
                      | (API Call)
                      v
                    [Python/Flask AI 서버]
```

- **Java (Tomcat) 서버**: 웹 페이지 렌더링, DB 연동, 회원 관리, 전체 비즈니스 로직 담당  
- **Python (Flask) 서버**: AI 모델(`best.pt`)을 실행하고 이미지 분석 요청을 처리하는 추론 API 서버  

---

## 🛠️ 기술 스택 (Tech Stack)

| 구분        | 기술 |
|-------------|--------------------------------|
| **Frontend** | HTML, CSS, JavaScript |
| **Backend (Main)** | Java, JSP & Servlet, Apache Tomcat 9.0 |
| **Backend (AI)** | Python, Flask|
| **AI Model** | YOLOv8 |
| **Database** | Oracle Database |
| **IDE & Tools** | Eclipse, Jupyter Notebook, VSCode, Git, GitHub |

---

## 🗂️ 데이터베이스 스키마 (ERD)
프로젝트는 **회원, 랜드마크, 게시글, 댓글, 즐겨찾기** 등을 포함한 총 8개 테이블로 구성되어 있습니다.  

---

## 🚀 시작하기 (Getting Started)

### 1. AI 서버 실행 (Python)
1) `ai_server` 폴더로 이동  
2) 필요한 라이브러리 설치  
```
pip install flask flask-cors ultralytics Pillow
```  
3) `best.pt` 모델 파일을 `ai_server` 폴더 안에 위치  
4) 서버 실행  
```
python app.py
```  
5) `http://127.0.0.1:5000` 에서 서버 실행 확인  

### 2. 메인 서버 실행 (Java)
1) Eclipse에서 Maven 프로젝트 Import  
2) `pom.xml` 의존성(Oracle JDBC, Gson 등) 설치  
3) `LandmarkDAO.java` (또는 `DBManager.java`)의 DB 접속 정보를 환경에 맞게 수정  
4) Tomcat 서버에 배포 후 실행  
5) 접속: `http://localhost:8081/{ContextPath}`  

### 3. 프론트엔드 실행
1) VSCode의 Live Server 확장 프로그램 실행  
2) `main.html` 열기  
3) `main.js`, `landmarkInfo.js` 등 JS 파일의 `fetch` 주소가 실행 중인 Tomcat 서버 주소와 일치하는지 확인  

---

## 👥 팀원 및 역할

| 이름 | 역할 |
|------|-------------------------------|
| 김명보 | 팀장, AI 모델 개발 및 학습 |
| 배준호 | 백엔드 개발, DB 설계 및 연동 |
| 진승준 | 프론트엔드 개발, UI/UX 설계 |
| 김효진 | QA, 데이터 수집 및 전처리 |
| 배종민 | QA, 데이터 수집 및 전처리 |
