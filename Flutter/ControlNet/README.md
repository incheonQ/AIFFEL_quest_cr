# 회고
## 강민구 :
지난번과 마찬가지로 이미지를 변환시키는 과정이 재미있었다. 프로젝트 마지막이 코랩의 gpu 리소스 부족으로 실행해보지 못한점이 아쉽다. 이후 다시한번 실행해볼 계획이다

## 김민규 :
ControlNet에 대해서 배웠다. ControlNet을 통해 prompt에 더해 추가적인 정보를 Diffusion Model에게 주어 결과물을 제어할 수 있다. 윤곽선 검출과 포즈 인식 두 가지를 각각 할 때는 결과물이 나쁘지 않았지만, 두 가지를 동시에 적용하면 결과물이 정말 퀄리티가 낮았다. 해당 문제를 어떻게 해결할 수 있을지 공부가 더 필요할 것 같다.

## 신상호 :
prompt와 negative prompt를 사용해서 출력 이미지를 직접 조정할 수 있는 점이 재미있었고 윤곽선 검출 관련 코드 부분은 낮설어서 좀 더 자주 접해야겠다고 느꼈습니다.

# 피어리뷰 템플릿

- [O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요? (완성도)**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 
    퀘스트 문제 요구조건 등을 지칭
        - 해당 조건을 만족하는 부분의 코드 및 결과물을 캡쳐하여 사진으로 첨부
    ![image](https://github.com/user-attachments/assets/ac10229d-1c3b-476e-97f2-44964825dd89)
    저희팀과 같이 원하시는 이미지가 나오진 않았지만 윤곽선 검출과 자세 검출은 제대로 된 결과를 확인하였습니다.

- [O]  **2. 프로젝트에서 핵심적인 부분에 대한 설명이 주석(닥스트링) 및 마크다운 형태로 잘 기록되어있나요? (설명)**
    - [O]  모델 선정 이유
    - [O]  하이퍼 파라미터 선정 이유
    - [O]  데이터 전처리 이유 또는 방법 설명

- [O]  **3. 체크리스트에 해당하는 항목들을 수행하였나요? (문제 해결)**
    - [O]  데이터를 분할하여 프로젝트를 진행했나요? (train, validation, test 데이터로 구분)
    - [O]  하이퍼파라미터를 변경해가며 여러 시도를 했나요? (learning rate, dropout rate, unit, batch size, epoch 등)
    - [O]  각 실험을 시각화하여 비교하였나요?
    - [O]  모든 실험 결과가 기록되었나요?

- [O]  **4. 프로젝트에 대한 회고가 상세히 기록 되어 있나요? (회고, 정리)**
    - [O]  배운 점
    - [O]  아쉬운 점
    - [O]  느낀 점
    - [O]  어려웠던 점

- [O]  **5.  앱으로 구현하였나요?**
    - [O]  구현된 앱이 잘 동작한다.
    - [O]  모델이 잘 동작한다.