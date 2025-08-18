# Landmark Search Service (YOLOv8 기반)

프로젝트 목표
사용자가 업로드한 랜드마크 이미지를 YOLOv8 기반 이미지 분류로 인식하고, 해당 랜드마크의 문화·역사·이용 정보와 지도 기반 주변 정보를 제공하는 웹 서비스입니다. 로그인과 즐겨찾기, 댓글/게시판, 마이페이지 등 커뮤니티 기능을 포함합니다.

핵심 기능
1) 인증
- 회원가입: 아이디(영문+숫자), 비밀번호 일치 확인, 이메일 중복 방지, 정보 저장
- 로그인/로그아웃: DB 정보와 일치 여부 검증, 실패 메시지 제공
- 계정 찾기: 이메일 기반 본인인증으로 아이디/비밀번호 찾기
2) 랜드마크 탐색
- 이미지로 찾기: 이미지 업로드 → 모델 추론 → 인식 결과와 DB의 LANDMARK_NAME_EN 비교 → 상세 페이지 이동
- 지도로 찾기: 세계 지도 인터랙션(이동/확대/축소/마커 클릭), 국가 선택 시 우측 랜드마크 카드 리스트 노출, 카드 클릭 시 상세 페이지 이동
3) 상세 정보 제공
- 메인 이미지 + 다각도 이미지 갤러리(썸네일 클릭 시 메인 교체)
- 기본 정보: 이름, 위치, 간략 설명, 완공 시기, 건축양식, 건축가, 운영시간, 이용요금, 교통정보, TMI, 공식 웹사이트, 용도, 태그
- 지도 정보: 포토스팟, 주변 맛집, 주변 명소 핀포인트와 탭
4) 커뮤니티/개인화
- 즐겨찾기(로그인 필요), 댓글/대댓글(게시판/상세페이지), 게시판 글 작성
- 마이페이지: 즐겨찾기 목록, 내가 작성한 댓글/게시글

유스케이스 요약
- 로그인(LMSS_100), 회원가입(LMSS_500)
- 이미지로 랜드마크 조회(LMSS_200)
- 지도로 랜드마크 조회(LMSS_300)
- 마이페이지(LMSS_400)

비기능 요구사항(성능/품질 목표)
- 가용성: 99.5% 이상
- 서버 응답: 3초 이내(네트워크 지연 제외)
- 화면 전환: 2초 이내
- 이미지 분석/가이드 생성: 5초 이내
- 보안: 비밀번호는 복호화 불가능한 해시로 저장
- 오류 처리: 입력/서버 오류 시 명확한 에러 메시지와 복구 방안
- UI/UX: 반응형, 최신 브라우저 호환
- 확장성: 랜드마크 10만 개 이상 확장 시에도 성능 저하 최소화

시스템 구성 제안
- 프론트엔드: React + TypeScript, 지도(Leaflet 또는 유사 라이브러리)
- 백엔드 API: Python FastAPI
- 모델 서빙: Ultralytics YOLOv8 분류(landmark labels), Torch 런타임
- 데이터베이스: Oracle (테이블 설계 기준)
- 스토리지: 이미지 정적 자원 저장소(S3 또는 내부 정적 서버)
- 인증: 세션 또는 JWT(중 하나 선택)

데이터 흐름(이미지 기반 탐색)
1) 사용자가 이미지 업로드
2) 백엔드가 YOLOv8 모델로 추론하여 랜드마크 영문명(label) 산출
3) DB의 LANDMARK_NAME_EN과 매칭
4) 일치하면 해당 LANDMARK_ID로 상세 정보 로드 후 반환

데이터베이스 설계(요약)
테이블 목록
- MEMBER: 서비스 사용자
- POST: 게시글
- LANDMARK: 랜드마크 상세 정보
- HOTSPOT: 랜드마크 주변 핫플레이스(포토스팟/맛집/명소 등)
- LANDMARK_IMAGE: 랜드마크 이미지(메인/다각도 구분)
- REPLY: 댓글
- FAVORITES: 즐겨찾기(회원-랜드마크 연결)
- LANDMARK_TAG: 태그
주요 컬럼(발췌)
- MEMBER(ID, PWD, EMAIL, NAME, NICKNAME) 등
- POST(POST_ID, CATEGORIES, TITLE, VIEWS, POST_DATE, POST_CONTENT, MEMBER_ID)
- LANDMARK(LANDMARK_ID, LANDMARK_NAME, LANDMARK_LOCATION, ARCHITECT, LANDMARK_DESC, LANDMARK_HOURS, FEE, TRAFFIC_INFO, TMI, ARCH_STYLE, WEBSITE, LANDMARK_USAGE, COMPLETION_TIME, LONGITUDE, LATITUDE, LANDMARK_NAME_EN)
- LANDMARK_IMAGE(IMAGE_ID, LANDMARK_ID, IMAGE_URL, IMAGE_TYPE)
- REPLY(REPLY_ID, MEMBER_ID, REPLY_DATE, REPLY_CONTENT, REFERENCE_ID)
- FAVORITES(FAVORITES_ID, MEMBER_ID, LANDMARK_ID)
- LANDMARK_TAG(TAG_ID, LANDMARK_ID, TAG_CONTENT)
제약조건(요약)
- LANDMARK.LANDMARK_NAME UNIQUE
- POST.MEMBER_ID → MEMBER.MEMBER_ID
- FAVORITES.MEMBER_ID → MEMBER.MEMBER_ID, FAVORITES.LANDMARK_ID → LANDMARK.LANDMARK_ID
- LANDMARK_IMAGE.LANDMARK_ID → LANDMARK.LANDMARK_ID
- REPLY.MEMBER_ID → MEMBER.MEMBER_ID

API 설계 초안
Auth
- POST /api/auth/signup
- POST /api/auth/login
- POST /api/auth/logout
- POST /api/auth/find-id, POST /api/auth/reset-password
Landmarks
- POST /api/landmarks/recognize  (이미지 업로드 후 인식 결과 반환)
- GET  /api/landmarks           (검색/페이징)
- GET  /api/landmarks/{id}      (상세)
- GET  /api/landmarks/{id}/images
- GET  /api/landmarks/{id}/hotspots?type=photo|food|sight
Map
- GET  /api/map/landmarks?country=KR  (국가 코드 등으로 필터)
Favorites
- POST /api/favorites/{landmarkId}
- DELETE /api/favorites/{landmarkId}
Posts/Replies
- GET  /api/posts
- POST /api/posts
- GET  /api/posts/{id}
- POST /api/posts/{id}/replies
My Page
- GET  /api/me/favorites
- GET  /api/me/posts
- GET  /api/me/replies

화면 구조(초안)
- 메인: 이미지 탐색 버튼, 세부 메뉴(사진으로 찾기, 지도로 찾기, 게시판, 로그인/회원가입)
- 이미지 탐색: 업로드 + 결과 페이지 이동
- 지도: 세계 지도, 국가 선택 시 우측 랜드마크 카드 리스트
- 랜드마크 상세: 메인/다각도 이미지, 상세 정보, 지도 탭(포토스팟/맛집/명소), 댓글
- 게시판: 글 목록, 상세, 댓글
- 마이페이지: 즐겨찾기/내 글/내 댓글

프로젝트 구조 제안(멀티 패키지 예시)
repo-root
  frontend/
    src/
      pages/
      components/
      api/
      hooks/
  backend/
    app/
      api/
      services/
      repositories/
      models/
      yolo/
    tests/
  db/
    schema/
    seed/
  docs/

환경 변수 예시
- ORACLE_HOST, ORACLE_PORT, ORACLE_SID, ORACLE_USER, ORACLE_PASSWORD
- JWT_SECRET, JWT_EXPIRES_IN
- STATIC_BASE_URL 또는 S3_BUCKET, S3_REGION

개발/실행 방법(예시)
1) DB 스키마 생성 및 샘플 데이터 시드
2) 모델 가중치(yolov8n-cls 등) 다운로드 후 backend/app/yolo 경로 배치
3) 백엔드 서버 실행(FastAPI)
4) 프론트엔드 실행(Vite dev server)
5) 이미지 업로드 또는 지도 탐색으로 기능 확인

성능/품질 점검 체크리스트
- 서버 응답/화면 전환/모델 추론의 SLA 충족 여부
- 해시 저장 여부와 토큰/세션 취약점 점검
- 오류 메시지 가이드라인 및 복구 플로우
- 반응형 레이아웃과 브라우저 호환성
- 10만 개 규모 랜드마크 데이터 성능 테스트

로드맵
- 알파: 기본 인증, 이미지 인식, 상세 페이지, 지도 탐색, 즐겨찾기, 댓글, 반응형 UI, 보안/오류 처리, 성능 목표(응답/전환/분석 시간) 적용
- 베타: 가용성 99.5% 목표, 장애 복구 플로우, 데이터 확장/튜닝, UX 개선

정합성/오탈자 메모
- 테이블 명세서의 댓글 테이블은 REPLY로 표기되어 있으며 COMMENT와 혼용되지 않도록 명확히 합니다.
- FAVORITES 테이블 설명의 “게시글 테이블과 연결” 문구는 오타로 보이며, 실제 외래키는 LANDMARK입니다.
- LONGITUDE/LATITUDE 철자와 컬럼 설명의 경도/위도 표기를 일관되게 유지합니다.

라이선스
- 필요 시 추후 추가합니다.

기여 방법
- 이슈/PR 템플릿과 브랜치 전략은 팀 내 협의 후 업데이트합니다.
