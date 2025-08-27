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
- **핫스팟 제안 기능**: 사용자는 랜드마크 주변의 '포토 스팟','주변 명소','주변 맛집'을 제안하고 운영자가 수락 시에 지도에 반영합니다.

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
| **Backend (Main)** | Java, JSP&Servlet, Apache Tomcat 9.0 |
| **Backend (AI)** | Python, Flask|
| **AI Model** | YOLOv8 |
| **Database** | Oracle Database |
| **IDE & Tools** | Eclipse, Jupyter Notebook, VSCode, Git, GitHub |

---

## 📌 테이블 개요

| 테이블명        | ID              | 설명                        |
|-----------------|-----------------|-----------------------------|
| **회원**        | MEMBER          | 서비스 사용자 정보           |
| **게시글**      | POST            | 회원이 작성한 게시물         |
| **랜드마크**    | LANDMARK        | 지역 명소 정보               |
| **이미지**      | LANDMARK_IMAGE  | 랜드마크별 이미지 정보       |
| **댓글**        | REPLY           | 회원이 작성한 댓글           |
| **즐겨찾기**    | FAVORITES       | 회원 즐겨찾기 랜드마크       |
| **태그**        | LANDMARK_TAG    | 랜드마크 태그 정보           |
| **핫스팟**      | HOTSPOT         | 랜드마크 주변 핫플 정보      |
| **제안**      | HOTSPOT_SUGGESTIONS | 랜드마크 주변 핫플 제안    |
---

## 🏷️ 테이블 정의

### 1. 회원 (MEMBER)
```sql
CREATE TABLE MEMBER(
    MEMBER_ID NUMBER(10) PRIMARY KEY NOT NULL,
    ID VARCHAR2(20) UNIQUE NOT NULL,
    PWD VARCHAR2(100) NOT NULL,
    EMAIL VARCHAR2(50) UNIQUE NOT NULL,
    NAME VARCHAR2(50) NOT NULL,
    NICKNAME VARCHAR2(30) UNIQUE NOT NULL,
    ROLL VARCHAR2(20) DEFAULT 'USER' NOT NULL
);
```

---

### 2. 게시글 (POST)
```sql
CREATE TABLE POST(
    POST_ID NUMBER(10) PRIMARY KEY NOT NULL,
    CATEGORIES VARCHAR2(50) NOT NULL,
    TITLE VARCHAR2(50) NOT NULL,
    VIEWS NUMBER(10),
    POST_DATE DATE,
    POST_CONTENT CLOB NOT NULL,
    POST_IMAGE_URL VARCHAR2(400),
    MEMBER_ID NUMBER(10),
    FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID) ON DELETE CASCADE
);
```

---

### 3. 랜드마크 (LANDMARK)
```sql
CREATE TABLE LANDMARK(
    LANDMARK_ID NUMBER(10) PRIMARY KEY NOT NULL,
    ARCHITECT VARCHAR2(100),
    LANDMARK_NAME VARCHAR2(100) NOT NULL UNIQUE,
    LANDMARK_LOCATION VARCHAR2(100) NOT NULL,
    LANDMARK_DESC VARCHAR2(4000),
    LANDMARK_HOURS VARCHAR2(100),
    FEE VARCHAR2(50),
    TRAFFIC_INFO VARCHAR2(4000),
    TMI VARCHAR2(4000),
    ARCH_STYLE VARCHAR2(100),
    WEBSITE VARCHAR2(100),
    LANDMARK_USAGE VARCHAR2(4000),
    COMPLETION_TIME VARCHAR2(100),
    LONGITUDE FLOAT,
    LATITUDE FLOAT,
    LANDMARK_NAME_EN VARCHAR2(100),
    HISTORY VARCHAR2(4000)
);
```

---

### 4. 랜드마크 이미지 (LANDMARK_IMAGE)
```sql
CREATE TABLE LANDMARK_IMAGE(
    IMAGE_ID NUMBER(10) PRIMARY KEY NOT NULL,
    LANDMARK_ID NUMBER(10),
    FOREIGN KEY (LANDMARK_ID) REFERENCES LANDMARK(LANDMARK_ID),
    IMAGE_URL VARCHAR2(4000),
    IMAGE_TYPE NUMBER(10)
);
```

---

### 5. 댓글 (REPLY)
```sql
CREATE TABLE REPLY(
    REPLY_ID NUMBER(10) PRIMARY KEY NOT NULL,
    REPLY_DATE DATE,
    REPLY_CONTENT CLOB,
    MEMBER_ID NUMBER(10),
    FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID) ON DELETE CASCADE,
    LANDMARK_ID NUMBER(10),
    FOREIGN KEY (LANDMARK_ID) REFERENCES LANDMARK(LANDMARK_ID),
    POST_ID NUMBER(10),
    FOREIGN KEY (POST_ID) REFERENCES POST(POST_ID) ON DELETE CASCADE
);
```

---

### 6. 즐겨찾기 (FAVORITES)
```sql
CREATE TABLE FAVORITES(
    FAVORITES_ID NUMBER(10) PRIMARY KEY NOT NULL,
    MEMBER_ID NUMBER(10),
    FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID) ON DELETE CASCADE,
    LANDMARK_ID NUMBER(10),
    FOREIGN KEY (LANDMARK_ID) REFERENCES LANDMARK(LANDMARK_ID)
);
```

---

### 7. 랜드마크 태그 (LANDMARK_TAG)
```sql
CREATE TABLE LANDMARK_TAG(
    TAG_ID NUMBER(10) PRIMARY KEY NOT NULL,
    LANDMARK_ID NUMBER(10),
    FOREIGN KEY (LANDMARK_ID) REFERENCES LANDMARK(LANDMARK_ID),
    TAG_CONTENT VARCHAR2(100)
);
```

---

### 8. 핫스팟 (HOTSPOT)
```sql
CREATE TABLE HOTSPOT(
    HOTSPOT_ID NUMBER(10) PRIMARY KEY NOT NULL,
    HOTSPOT_NAME VARCHAR2(100),
    HOTSPOT_LONG FLOAT,
    HOTSPOT_LATI FLOAT,
    HOTSPOT_TYPE VARCHAR2(100),
    HOTSPOT_INFO VARCHAR2(4000),
    LANDMARK_ID NUMBER(10)
);
```

---

### 9. 제안 (HOTSPOT_SUGGESTIONS)
```sql
CREATE TABLE HOTSPOT_SUGGESTIONS (
    SUGGESTION_ID NUMBER(10) PRIMARY KEY NOT NULL,
    MEMBER_ID NUMBER(10) NOT NULL,
    LANDMARK_ID NUMBER(10) NOT NULL,
    HOTSPOT_TYPE VARCHAR2(100) NOT NULL,
    HOTSPOT_NAME VARCHAR2(100) NOT NULL,
    HOTSPOT_INFO VARCHAR2(4000),
    HOTSPOT_LATI FLOAT NOT NULL,
    HOTSPOT_LONG FLOAT NOT NULL,
    STATUS VARCHAR2(20) DEFAULT 'pending' NOT NULL,
    SUGGESTED_AT DATE DEFAULT SYSDATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID) ON DELETE CASCADE,
    FOREIGN KEY (LANDMARK_ID) REFERENCES LANDMARK(LANDMARK_ID)
);
```

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
사용자가 접속할 메인 웹사이트를 구동합니다.
1) Eclipse에서 Maven 프로젝트 Import
2) `pom.xml` 의존성(Oracle JDBC, Gson 등) 설치  
3) `src/main/java` 경로에 있는 `LandmarkDAO.java` 파일의 DB 접속 정보를 본인의 Oracle DB 환경에 맞게 수정합니다. 
4) Tomcat 서버에 배포 후 실행  
5) 접속: `[http://localhost:8081/{ContextPath}](http://localhost:8081/{프로젝트 컨텍스트 경로}/main.jsp)` 

---

## 👥 팀원 및 역할

| 이름 | 역할 |
|------|-------------------------------|
| 김명보 | 팀장, AI 모델 개발 및 학습 |
| 김효진 | 백엔드 개발, DB 설계 및 연동 |
| 진승준 | 프론트엔드 개발, UI/UX 설계 |
| 배준호 | QA, 데이터 수집 및 전처리, 문서 작성 |
| 배종민 | QA, 데이터 수집 및 전처리, 문서 작성 |
