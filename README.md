# 📝 Tasks (To-Do App) v3.0

Clean Architecture와 Riverpod 기반의 할 일 관리 앱입니다.
아키텍처 원칙을 준수하여 대량의 데이터 환경에서도 끊김 없는 쾌적한 경험을 제공합니다.

---

## 🛠 Tech Stack & Libraries

### 1. Framework & Architecture

- Flutter (SDK ^3.10.1)
- Clean Architecture: Domain, Data, Ui 레이어 분리
- Riverpod: 최신 Notifier 기반의 의존성 주입 및 상태 관리
- Go Router: 선언적 라우팅 시스템 구축

### 2. Infrastructure & Data

- Firebase Core & Cloud Firestore: 실시간 데이터베이스 연동

---

## 📸 실행 화면 (Screenshots)

### Home Page

<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 15 51" src="https://github.com/user-attachments/assets/84c079ca-19e0-4e0d-b899-2aff026b8be5" />
<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 24 11" src="https://github.com/user-attachments/assets/cf2994ed-05cd-47fb-87e5-46e58e4d90ba" />
<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 24 18" src="https://github.com/user-attachments/assets/5b1b45ac-e1f8-4d72-8ab5-c8b82151733d" />
<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 24 21" src="https://github.com/user-attachments/assets/57f145c4-ea96-4d69-b642-d1b2c2f65167" />

### Add Task (BottomSheet)

<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 18 12" src="https://github.com/user-attachments/assets/76e64e9f-4987-4f16-a954-b83b0ba08e34" />

### Detail View & Edit

<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 18 30" src="https://github.com/user-attachments/assets/21723fcc-5418-4bea-8ed4-0500bfd93235" />
<img width="482" height="842" alt="스크린샷 2026-02-05 오전 10 18 48" src="https://github.com/user-attachments/assets/99164076-ff4e-4e65-92d4-9ca330878b57" />


## 📂 폴더 구조 (Folder Structure)

```
lib/
├── core/               # 앱 전역 공통 설정 및 유틸리티
├── data/
│   ├── datasource/     # 데이터 소스 인터페이스 및 구현 (Firestore)
│   ├── dto/            # 데이터 전송 객체 (Firestore DTO, Statistics DTO)
│   └── repository/     # 리포지토리 구현체 및 테스트용 Mock 데이터
├── domain/
│   ├── entity/         # 순수 비즈니스 모델 (Entity, PageResult, Statistics)
│   ├── repository/     # 도메인 리포지토리 인터페이스
│   └── usecase/        # 핵심 비즈니스 로직 (GetStatisticsUseCase)
├── ui/                 # 프레젠테이션 레이어 (ViewModel, Widgets, Pages)
├── firebase_options.dart
└── main.dart
test/
└── repository/         # 리포지토리 단위 테스트 (to_do_repository_test.dart)
```

---

## 기능 구현 상세 (Feature List)

### ✨ 필수 기능 (Essential Features)

#### 클린 아키텍처 기반 패키지 리팩토링
앱의 구조를 core, data, domain, ui로 나누어 계층 간 독립성을 확보했습니다.

- Core: 라우터, 테마, 유틸리티 등 공통 설정 파일 배치
- Data: 데이터 소스 구현체와 DTO, 리포지토리 실체를 관리
- Domain: 비즈니스 로직의 핵심인 엔티티와 리포지토리 인터페이스, 유스케이스를 배치

#### Go Router를 이용한 페이지 전환
선언적 라우팅 시스템을 구축하고 페이지 간 이동을 효율적으로 관리합니다

#### 이벤트 제어 (Throttling)
터치 버튼들에 직접 구현한 로직을 적용하여 짧은 시간 내 중복 클릭으로 인한 오류를 방지했습니다.

#### Hero 위젯을 활용한 시각 효과
홈 화면의 할 일 제목과 상세 화면의 제목을 Hero 위젯으로 연결하여 매끄러운 화면 전환 애니메이션을 구현했습니다.

### 💪 도전 기능 및 추가 구현 (Challenge & Custom)

#### 인피니트 스크롤 및 Pull to Refresh
Firestore의 커서 기반 페이징을 활용하여 한 번에 15개씩 데이터를 호출하도록 구현했습니다.
사용자가 바닥에 닿기 전 미리 다음 데이터를 불러와 끊김 없는 스크롤을 제공합니다.

RefreshIndicator를 사용하여 위에서 아래로 당길 때 데이터와 통계가 즉시 갱신되도록 처리했습니다.

#### 반응형 UI 구성
화면 방향 가로/세로 전환 시 레이아웃이 무너지지 않도록 유동적인 대시보드와 리스트 구조를 설계했습니다.

#### 단위 테스트(Unit Test) 작성
TodoRepository에 대한 단위 테스트 코드를 작성하여 데이터 CRUD 및 페이징 로직의 안정성을 검증했습니다.

#### 나만의 기능: 실시간 통계 대시보드
할 일 리스트 상단에 전체 할 일의 완료 현황을 볼 수 있는 대시보드를 추가했습니다.
인피니트 스크롤 환경에서도 전체 데이터의 수치를 정확히 보여주기 위해 Firestore count() 집계 쿼리와 Future.wait 병렬 처리를 도입했습니다.

---

## 🚀 트러블 슈팅 (Trouble shooting)

### 1. 클린 아키텍처 도입과 계층 분리

문제: MVVM에서 클린 아키텍쳐로 전환 시 로직의 적절한 계층 분류 및 Firebase 기술 종속성 해결 고민
해결: DataSource를 별도 분리하여 저수준 명령어를 캡슐화하고, Domain 계층의 인터페이스를 통해 실제 DB와 Mock 데이터를 코드 한 줄로 교체 가능한 유연한 구조 설계

### 2. 안정적인 인피니트 스크롤 구현

문제: 기존 페이지 번호 방식의 데이터 중복/누락 문제 및 스크롤 시 흐름 끊김 현상
해결: 마지막 데이터 위치를 기억하는 커서 방식으로 상태(TodoListState)를 재설계하고, 바닥에 닿기 전 미리 로딩하는 Pre-fetching 기법 적용

### 3. 인피니트 스크롤과 전체 통계의 데이터 정합성

문제: 리스트는 부분 로딩되는데 상단 통계는 전체를 보여줘야 하여, 스크롤 시 수치가 요동치는 버그 발생
해결: 리스트와 통계 로직을 완전 분리. Firestore count() 집계 쿼리와 Future.wait 병렬 처리를 도입하여 리소스 비용은 아끼면서 정확한 전체 수치 유지
