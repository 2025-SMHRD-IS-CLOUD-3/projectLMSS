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

## 🛠️ 기술 스택 (Tech Stack)

| 구분        | 기술 |
|-------------|--------------------------------|
| **Frontend** | HTML, CSS, JavaScript |
| **Backend (Main)** | Java, JSP&Servlet, Apache Tomcat 9.0 |
| **Backend (AI)** | Python, Flask|
| **AI Model** | YOLOv8 |
| **Database** | Oracle Database |
| **IDE & Tools** | Eclipse, Jupyter Notebook, GitHub, Figma |

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
<details> <summary>📌 클릭해서 펼치기</summary>




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
</details>

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

## :books: 유스케이스 다이어그램

<img width="765" height="732" alt="image" src="https://github.com/user-attachments/assets/fe9f2a4a-b683-4557-a182-a5e47f1adb76" />

---

## :green_book: 서비스 흐름도

<img width="1486" height="698" alt="image" src="https://github.com/user-attachments/assets/cd06a4ea-fa51-4818-bdf7-daa15c613326" />

---

## 🏛️ 시스템 아키텍쳐

<img width="763" height="393" alt="image" src="https://github.com/user-attachments/assets/96d809de-bb20-4526-90cc-10b0025c3ddf" />

---

## :computer: ER 다이어그램

<img width="1273" height="698" alt="image" src="https://github.com/user-attachments/assets/79d6f36e-d74b-49c2-9c52-14e16586032a" />

---

## 📝 화면 설계

### 메인 페이지
<img width="1911" height="918" alt="image" src="https://github.com/user-attachments/assets/ec2dbfcb-2c3a-468f-ab3b-e2869658caee" />

### 정보 페이지
<img width="1913" height="902" alt="image" src="https://github.com/user-attachments/assets/063ee543-d625-4227-8d86-f7a602c78a19" />

### 정보 페이지 2
<img width="1920" height="805" alt="image" src="https://github.com/user-attachments/assets/d0cf1335-53a3-4831-a145-dc42f4fbc14e" />

### 지도 페이지
<img width="1920" height="915" alt="image" src="https://github.com/user-attachments/assets/e8bac2f2-7f1b-48a4-8d32-595e5b4a77c5" />

### 게시판 페이지
<img width="1920" height="919" alt="image" src="https://github.com/user-attachments/assets/ea86b06c-e9a6-4212-bf20-750b11f098b7" />

### 마이 페이지
<img width="1920" height="915" alt="image" src="https://github.com/user-attachments/assets/a4795ac2-169e-4721-887b-beac70c4df10" />

### 핫스팟 제안 페이지
<img width="1920" height="914" alt="image" src="https://github.com/user-attachments/assets/9600d488-dde1-4ffa-a3a9-67674fa4a9b0" />

### 핫스팟 제안 관리 페이지
<img width="1920" height="885" alt="image" src="https://github.com/user-attachments/assets/d01c0bd4-1a73-44f3-a954-10ca3993bcb7" />

---

## 🚨 트러블 슈팅

### 외부 이미지 URL 접근 차단
:x: **문제 현상**:
DB에 저장된 imgur.com 이미지 URL을 <img> 태그의 src에 직접 사용했으나, 이미지가 표시되지 않고 브라우저 콘솔에 `403 Forbidden` 오류가 발생했습니다.

🔍 **원인 분석**:
Imgur와 같은 다수의 이미지 호스팅 서비스는 다른 웹사이트가 자신의 이미지 리소스를 직접 링크하여 트래픽을 유발하는 핫링킹(Hotlinking)을 방지합니다. 브라우저가 이미지를 요청할 때 보내는 Referer 헤더를 확인하여, 허가되지 않은 사이트에서의 요청을 차단하는 것입니다.

✔️ **해결 과정**:
두 가지 방법을 병행하여 해결했습니다.
Referrer Policy 설정: HTML의 <head> 태그에 `<meta name="referrer" content="no-referrer">`를 추가하여, 이미지 요청 시 브라우저가 출처(Referer) 정보를 보내지 않도록 했습니다.
URL 동적 변환: imgur.com/IMAGE_ID 형태의 페이지 URL을 i.imgur.com/IMAGE_ID.jpg 형태의 직접 이미지 링크로 변환하고, .jpg, .png 등 여러 확장자를 시도하여 유효한 링크를 찾아내는 JavaScript 함수를 구현하여 안정성을 높였습니다.

### Oracle DB 시퀀스 불일치로 인한 unique constraint 위반
:x: **문제 현상**:
관리자 페이지에서 핫스팟 제안을 [승인]하면 HotspotDAO에서 `ORA-00001: unique constraint ... violated` 오류가 발생하며 DB에 데이터가 추가되지 않았습니다. 테이블을 초기화하고 다시 시도해도 동일한 문제가 반복되었습니다.

🔍 **원인 분석**:
INSERT 쿼리는 HOTSPOT_SEQ.NEXTVAL을 사용하여 HOTSPOT_ID를 자동으로 생성하고 있었습니다. 하지만 이전에 데이터를 수동으로 추가/삭제하는 과정에서 HOTSPOT 테이블에 이미 존재하는 ID(예: 5번)와, 시퀀스가 다음에 생성하려는 ID(예: 5번)가 겹치는 문제가 발생했습니다. 즉, '번호표 기계'가 이미 발급된 번호를 다시 발급하려고 시도한 것입니다.

✔️ **해결 과정**:
'번호표 기계'(시퀀스)를 수리하는 방식으로 해결했습니다.
`SELECT MAX(HOTSPOT_ID) FROM HOTSPOT;` 쿼리로 현재 테이블에 있는 가장 큰 ID 값을 확인했습니다.
`DROP SEQUENCE HOTSPOT_SEQ;`로 기존 시퀀스를 삭제했습니다.
`CREATE SEQUENCE HOTSPOT_SEQ START WITH [가장 큰 ID + 1];` 명령으로, 현재 데이터와 절대 겹치지 않는 번호부터 시작하는 새로운 시퀀스를 생성하여 문제를 해결했습니다.

### CSS `z-index` 오작동
:x: **문제 현상**:
사이드 메뉴가 열렸을 때, 메뉴 버튼의 z-index 값을 사이드 메뉴보다 훨씬 높게 설정했음에도 불구하고 버튼이 메뉴 뒤로 숨는 현상이 발생했습니다.

🔍 **원인 분석**:
문제는 CSS의 쌓임 맥락(Stacking Context) 규칙 때문이었습니다. 메뉴 버튼이 `position: fixed`와 `z-index`가 적용된 `<header>` 요소의 자식으로 있었기 때문에, 버튼의 `z-index`는 `<header>`의 쌓임 맥락 안에서만 유효했습니다. 결국 `<header>` 전체가 `z-index`가 더 높은 사이드 메뉴 뒤로 가려지면서 버튼도 함께 숨겨진 것이었습니다.

✔️ **해결 과정**:
메뉴 버튼`(<button class="menu-btn">)`을 `<header>` 태그 밖으로 꺼내어 독립적인 쌓임 맥락을 갖도록 HTML 구조를 변경했습니다. 이를 통해 `z-index` 값이 전역적으로 올바르게 적용되어 사이드 메뉴 위에 버튼이 항상 표시되도록 문제를 해결했습니다.

## 👥 팀원 및 역할

| 이름 | 역할 |
|------|-------------------------------|
| 김명보 | 팀장, AI 모델 개발 및 학습 |
| 김효진 | 백엔드 개발, DB 설계 및 연동 |
| 진승준 | 프론트엔드 개발, UI/UX 설계 |
| 배준호 | QA, 데이터 수집 및 전처리, 문서 작성 |
| 배종민 | QA, 데이터 수집 및 전처리, 문서 작성 |
