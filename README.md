# 📝 Tasks (To-Do App) v2.0

Firebase와 Open-Meteo API를 연동한 MVVM 패턴 기반의 Flutter 할 일 관리 애플리케이션입니다.
할 일 데이터는 Firestore에 저장되며 사용자의 현재 위치에 따른 날씨 정보를 제공합니다.

---

## 🛠 Tech Stack & Libraries

이번 프로젝트는 MVVM 아키텍처를 기반으로 설계되었으며, 실무 표준에 가까운 생산성을 확보하기 위해 아래 패키지들을 전략적으로 도입했습니다.

### 1. 상태 관리 및 로직 분리

**flutter_riverpod**: Notifier와 Provider를 활용하여 상태 변경 흐름을 명확히 관리하고,
UI와 비즈니스 로직을 분리했습니다.

### 2. 데이터 모델링 (Immutable Data)

**freezed & json_serializable**: 불변성(Immutable) 데이터 모델을 자동으로 생성하여 데이터 안정성을 높이고, JSON 직렬화 로직을 자동화했습니다.

### 3. 인프라 및 데이터 통신

**firebase_core & cloud_firestore**: Firebase를 연동하여 실시간 데이터베이스 환경을 구축했습니다.

**dio & http**: 외부 날씨 API(Open-Meteo)와의 통신을 위해 사용했습니다.

**geolocator**: 사용자의 실시간 GPS 좌표를 취득하여 위치 기반 서비스를 구현했습니다.

### 4. 유틸리티

**intl**: 날짜 및 시간 데이터를 한국 표준 형식으로 변환하기 위해 사용했습니다.

---

## 📸 실행 화면 (Screenshots)

### Main & Weather View (Empty)

<img width="410" height="857" alt="스크린샷 2026-01-12 오후 11 57 38" src="https://github.com/user-attachments/assets/7b5f98e9-800f-4a82-ae62-d48cff63d206" />

<img width="410" height="857" alt="스크린샷 2026-01-12 오후 11 58 39" src="https://github.com/user-attachments/assets/33ce6df1-a9b0-480b-83da-79debef15ffb" />



### Add Task (BottomSheet)

<img width="410" height="857" alt="스크린샷 2026-01-12 오후 11 57 46" src="https://github.com/user-attachments/assets/7b68a17b-84f2-41c7-a25e-d2ff91ab1770" />


### Detail View & Edit

<img width="410" height="857" alt="스크린샷 2026-01-12 오후 11 58 14" src="https://github.com/user-attachments/assets/d44efbd0-299d-4cda-a4b7-3af52ff65dca" />


### Dark Mode

<img width="410" height="857" alt="스크린샷 2026-01-12 오후 11 58 25" src="https://github.com/user-attachments/assets/1e638d62-c440-4faf-8e7e-1a213a7bb4f6" />


## 📂 폴더 구조 (Folder Structure)

데이터 모델(models)과 UI(pages)를 분리하여, 여러 화면에서 데이터를 쉽게 공유할 수 있도록 구조화했습니다.

```
lib/
├── data/
│   ├── core/
│   │   └── geolocator_helper.dart      # GPS 위치 권한 및 좌표 취득 헬퍼
│   ├── model/
│   │   ├── todo_entity.dart           # To-Do 데이터 모델 (Freezed)
│   │   ├── todo_entity_firestore.dart # Firestore 저장 전용 Extension 로직
│   │   └── weather_model.dart         # 기상 정보 데이터 모델 (Freezed)
│   └── repository/
│       ├── todo_repository.dart       # Firestore CRUD 로직 처리
│       └── weather_info_repository.dart # Open-Meteo API 통신 처리
├── ui/
│   └── pages/
│       ├── detail/
│       │   └── detail_page.dart       # 할 일 상세 보기 및 수정 페이지
│       ├── home/
│       │   ├── widgets/               # 홈 화면 전용 위젯 (하단 바, empty 등)
│       │   ├── home_page.dart         # 메인 홈 화면
│       │   ├── home_view_model.dart   # 할 일 상태 관리 (Riverpod Notifier)
│       │   └── weather_info_view_model.dart # 날씨 상태 관리 (Riverpod Notifier)
│       ├── todo_list/
│       │   ├── widgets/               # 리스트 아이템 개별 위젯
│       │   └── todo_list_page.dart    # 할 일 목록 표시 페이지
│       └── write_todo/
│           └── write_todo.dart        # 할 일 추가 바텀 시트
└── utils/
    ├── dialog_utils.dart              # 공통 다이얼로그(확인/취소) 유틸
    └── snackbar_utils.dart            # 공통 스낵바 알림 유틸
```

### 구조 설계 특징

**Data Layer**: model과 repository를 통해 데이터의 출처(Firebase/API)와 형식을 관리합니다.

**UI Layer**: 각 페이지(pages)별로 관련 view_model과 widgets를 모아두어 코드 응집도를 높였습니다.

**MVVM**: view_model이 상태 관리를 담당하고, view는 UI 렌더링에만 집중하도록 설계했습니다.

**Utils**: 앱 전역에서 반복적으로 사용되는 UI 피드백 로직을 모듈화했습니다.

---

## 기능 구현 상세 (Feature List)

### ✨ 필수 기능 (Essential Features)

#### 1. MVVM 패턴 및 Riverpod 적용

**구조 설계**: Notifier와 NotifierProvider를 사용하여 비즈니스 로직과 UI를 완전히 분리했습니다.

**데이터 관리**: HomeViewModel을 통해 Firestore의 데이터를 구독하고 상태를 업데이트합니다.

#### 2. Firebase Firestore CRUD

**데이터 저장**: TodoRepository를 통해 모든 할 일을 Firestore에 실시간으로 쓰고 읽습니다.

**모델링**: Freezed를 사용하여 불변(Immutable) 모델을 정의했습니다.

#### 3. 할 일 추가 및 상세 보기

**WriteTodo**: 제목 입력 여부에 따라 저장 버튼을 활성화하여 빈 데이터 생성을 방지합니다.

**DetailPage**: 할 일의 제목과 세부 정보를 수정할 수 있으며 상태 변경 시 메인 화면에 즉시 반영되도록 설계했습니다.

### 💪 도전 기능 및 추가 구현 (Challenge & Custom)

#### 1. 위치 기반 날씨 정보 (GPS & Weather API)

**Geolocator**: 현재 위치의 위도와 경도를 실시간으로 가져옵니다.

**Weather API**: Open-Meteo API를 연동하여 현재 기온과 날씨 정보를 하단 바에 표시합니다.

#### 2. 사용자 경험(UX) 개선 기능

**새로고침 인디케이터**: 메인 리스트를 아래로 당겨 데이터와 날씨를 수동 갱신할 수 있습니다.

**삭제 취소 (Undo)**: 할 일 삭제 시 스낵바에 '취소' 버튼을 제공하여, 실수로 삭제한 데이터를 복구합니다.

---

## 🚀 트러블 슈팅 (Trouble shooting)

### 🧨 1. 상세 페이지 삭제 시 에러 화면

**문제**: 상세 페이지에서 할 일 삭제 시, 화면 전환 직전 찰나의 순간에 빨간색 에러 화면 노출.

**원인**: Navigator.pop 애니메이션 진행 중 상태가 먼저 변경되면서 build 메서드가 삭제된 데이터를 다시 참조해 예외가 발생.

**해결**:

- Navigator.pop을 데이터 삭제 로직보다 먼저 호출하도록 순서 조정.
- firstOrNull 및 삼항 연산자를 활용하여 데이터 부재 시 로딩 UI를 렌더링하는 방어 로직 구축.

### ⏳ 2. 액션 버튼 포함 시 스낵바 자동 종료 불가

**문제**: 삭제 취소용 SnackBarAction 추가 시, 설정한 duration이 지나도 스낵바가 닫히지 않는 현상 발생.

**원인**: action 파라미터 추가 시 상호작용 보장을 위해 내부적으로 persist: true가 기본 설정됨을 확인.

**해결**: 스낵바 생성 시 persist: false 옵션을 명시적으로 부여하여 자동 종료 기능 회복.

### 🧩 3. Firestore 데이터 내 중복 ID 필드 저장

**문제**: 모델의 id 필드가 Firestore 문서 내부 필드(data)에도 중복 저장되어 데이터 구조 비효율화.

**원인**: Freezed 모델의 toJson()이 모든 필드를 포함하여 발생하는 현상.

**해결**: Extension을 활용한 toFirestore() 메서드 정의. 저장 직전 id 필드만 제거하도록 구현하여 DB 구조 최적화.

### 🔄 4. 새로고침 인터페이스(UI/UX) 개선

**문제**: 하단 바의 새로고침 버튼이 메인 기능인 할 일 목록보다 시각적으로 두드러져 UX 저해.

**원인**: 버튼 방식은 UI가 복잡해지고 모바일 특유의 직관적인 제스처를 활용하지 못함.

**해결**: 아이콘 버튼 삭제 및 RefreshIndicator 적용. 'Pull to Refresh' 패턴 도입으로 할 일 목록과 날씨 정보를 동시 갱신하는 직관적 UX 구현.
