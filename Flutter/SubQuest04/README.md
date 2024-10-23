
# Perplexity 앱 분석 및 역설계 하기

## 앱 정보

- **앱 이름** 

  - Perplexity   

- **시장(마켓)**  

  - Perplexity는 AI 기반 검색 시장에서 빠르게 성장하고 있으며, 현재 구글 대비 0.2% 수준의 검색 점유율을 보유하고 있습니다.
  - 하루 평균 2.5억 회의 검색량을 기록하고 있어, 신생 기업임에도 의미있는 시장 침투율을 보여주고 있습니다.

- **타겟**  

  - 주요 사용자 그룹 : 전문가 및 지식 근로자, 학생층
  - 지역별 타겟 시장 : 인도네시아 (전체 사용자의 24.78%, 1298만 명), 인도 (22.16%, 1161만 명), 미국(16.22%, 850만 명)
 
## 앱 구조도
- 레이블링과 허브앤스포크 구조가 섞인 방식
[앱 구조도](https://www.tldraw.com/s/v2_c_qdnAq8RMNsXqIInBrkYjM?d=v-1636.-4170.9580.9180.page)

## 앱 와이어 프레임 (사용 툴 : InVision)
[와이어 프레임](https://913056.invisionapp.com/freehand/--------eOeRJveLB)

## 프로토타이핑 (사용 툴 : Marvel App)
[프로토타이핑](https://marvelapp.com/prototype/7028dd4/screen/95832715)

## 페이지 구현

### 1. 메인 앱 (Perplexity)
- MaterialApp 사용
- 테마: 파란색 계열

### 2. HomePage
- BottomNavigationBar로 3개 페이지 간 네비게이션
  - MainPage
  - SearchPage
  - Threadpage

### 3. MainPage
- AppBar: 'Perplexity Pro' 제목, 프로필 및 친구 초대 아이콘
- 앱 로고 및 "지식이 시작되는 곳" 문구
- 추천 검색어 버튼 목록
- 하단 검색 입력 필드, 첨부 파일 및 음성 인식 버튼

### 4. SearchPage
- AppBar: '검색' 제목, 설정 아이콘
- 카테고리 버튼 (주요뉴스, 테크 & 과학, 예술 & 문화)
- 스크롤 가능한 게시글 목록 (이미지, 텍스트, 북마크, 음성 재생 버튼)

### 5. Threadpage
- AppBar: 검색 아이콘, 새 스레드 추가 버튼
- '스레드'와 '컬렉션' 탭
- 스레드 목록 (제목, 이미지 미리보기, 시간 정보)

### 6. UserProfilePage
- AppBar: '계정관리' 제목, GitHub 링크 버튼
- 사용자 프로필 정보 및 계정 관리 링크
- 앱 설정 옵션 (Pro 기능, AI 모델, 테마, 언어, 알림 등)
- '도움말 & 지원' 섹션

### 7. SearchResultPage
- AppBar: 뒤로 가기 버튼, 검색어 표시, 추가 옵션 버튼
- 상단 검색 입력 필드 (첨부 파일 및 음성 인식 버튼 포함)
- 검색 결과 표시 영역

## 구현 영상

## 회고
Flutter 공부는 주말을 통해 깊이 할 예정입니다.
대부분의 코드 작성은 Cursor의 AI 챗봇 기능을 활용하였습니다.
