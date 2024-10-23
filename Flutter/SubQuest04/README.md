
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
- [앱 구조도](https://www.tldraw.com/s/v2_c_qdnAq8RMNsXqIInBrkYjM?d=v-1636.-4170.9580.9180.page)

## 앱 와이어 프레임 (사용 툴 : InVision)
- [와이어 프레임](https://913056.invisionapp.com/freehand/--------eOeRJveLB)

## 프로토타이핑 (사용 툴 : Marvel App)
- [프로토타이핑](https://marvelapp.com/prototype/7028dd4/screen/95832715)

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
<img src="https://github.com/incheonQ/AIFFEL_quest_cr/blob/main/Flutter/SubQuest04/AndroidEmulator-test_55542024-10-2312-25-17-ezgif.com-video-to-gif-converter.gif" width="320" height="720">

## 회고
Flutter 공부는 주말을 통해 깊이 할 예정입니다.
대부분의 코드 작성은 Cursor의 AI 챗봇 기능을 활용하였습니다.

# 피어 리뷰
<aside>

- [O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 문제에서 요구하는 기능이 정상적으로 작동하는지?
        - 해당 조건을 만족하는 부분의 코드 및 결과물을 근거로 첨부
        ![image](https://github.com/user-attachments/assets/0956cdea-c838-4d5b-a242-46cb12062024)

        다양한 기능들이 정상적으로 작동합니다.
    
- [O]  **2. 핵심적이거나 복잡하고 이해하기 어려운 부분에 작성된 설명을 보고 해당 코드가 잘 이해되었나요?**
    - 해당 코드 블럭에 doc string/annotation/markdown이 달려 있는지 확인
    - 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
    - 주석을 보고 코드 이해가 잘 되었는지 확인
        - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.
        ![image](https://github.com/user-attachments/assets/80701732-4ec7-4b03-acbe-73eaa105b0d4)

        위 코드뿐만 아니라 다른 코드에서도 고찰한 모습이 느껴지는 주석들이 많았습니다.
        
- [O]  **3.** 에러가 난 부분을 디버깅하여 “문제를 해결한 기록”을 남겼나요? 또는
   “새로운 시도 및 추가 실험”을 해봤나요? ****
    - 문제 원인 및 해결 과정을 잘 기록하였는지 확인 또는
    - 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 
    실험이 기록되어 있는지 확인
        - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.
    따로 오류난 부분 없이 잘 작동했습니다.
    
- [O]  **4. 회고를 잘 작성했나요?**
    - 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록 되어 있나요?
      ![image](https://github.com/user-attachments/assets/c033cb86-24a7-4cf5-83ed-495deca6072f)
      어떤 툴을 활용했는지 작성해주셨고 부족한점을 느끼고 앞으로 어떻게 할지 정리하신부분에서 자극을 느꼈습니다.

- [O]  **5. 코드가 간결하고 효율적인가요?**
    - 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 모듈화(함수화) 했는지
        - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.
    ![image](https://github.com/user-attachments/assets/8fbb0643-bac8-4ce1-af3f-0afe0bd20e7b)
    함수화까진 아니지만 그래도 하나의 리스트 작성해 코딩했다고 생각합니다.
    
</aside>
