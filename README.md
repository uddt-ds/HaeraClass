# 📚 해라클래스 (HaeraClass)

## 📚 목차
1. [프로젝트 소개](#project-intro)
2. [주요기능](#features)
3. [개발기간](#duration)
4. [기술스택](#tech-stack)
5. [기술적 의사결정](#tech-decision)
6. [프로젝트 구조](#project-structure)
7. [샘플이미지](#sample-images)

<a id="project-intro"></a>
## 🌤 프로젝트 소개

- 해라클래스는 다양한 클래스(강의)를 조회하고 후기를 작성할 수 있는 클래스 정보 공유 앱입니다.
- 카테고리별 클래스(개발, 디자인, 외국어 등)를 필터링할 수 있습니다.
- 클래스 상세 정보를 확인하고 좋아요, 댓글 기능을 통해 소통할 수 있습니다.
- 관심 있는 클래스를 찜하고 후기를 작성하여 다른 사용자들과 정보를 공유할 수 있습니다.

<a id="features"></a>
## 🛠 주요기능

### 클래스 목록 조회 및 카테고리 필터링
- **카테고리 필터**: 8개 카테고리 필터링
- **다중 카테고리 선택**: 여러 카테고리 동시 선택 가능
- **정렬 기능**: 최신순/가격순 정렬 토글 지원
- **할인율 표시**: 원가 대비 할인가 비율 자동 계산
- **찜 기능**: 관심 있는 클래스 찜하기

### 클래스 상세 정보
- **이미지 슬라이더**: CollectionView 기반 이미지 갤러리 (페이징 지원)
- **강사 정보**: 강사 프로필 이미지 및 닉네임 표시
- **클래스 정보**: 제목, 가격, 카테고리, 설명 등 상세 정보 제공
- **좋아요 토글**: 클래스 좋아요 추가/취소 (하트 아이콘 애니메이션)
- **댓글 개수 실시간 업데이트**: NotificationCenter를 통한 댓글 수 동기화

### 댓글 및 후기 작성
- **댓글 목록 조회**: 클래스별 댓글 목록 TableView 표시
- **댓글 작성/수정**: 2자 이상 200자 이하 댓글 작성 (공백 제외 글자 수 카운팅)
- **댓글 삭제**: 본인이 작성한 댓글 삭제 가능
- **실시간 글자 수 표시**: 150자 이상 시 빨간색 경고 표시
- **유효성 검증**: 최소/최대 글자 수 체크 및 저장 버튼 활성화 제어

### 클래스 검색
- **키워드 검색**: 클래스 제목으로 검색
- **검색 결과 표시**: 매칭되는 클래스 목록 표시
- **빈 결과 처리**: "검색 결과가 없습니다" 메시지 표시

### 로그인/로그아웃
- **이메일 로그인**: 이메일 및 비밀번호 기반 로그인
- **유효성 검증**:
  - 이메일: @ 및 .com 포함 확인, 30자 이하
  - 비밀번호: 2자 이상 10자 미만
- **자동 로그인**: UserDefaults에 토큰 저장을 통한 자동 로그인 지원
- **로그아웃**: UserDefaults 토큰 삭제

<a id="duration"></a>
## 📅 개발기간

| 버전 | 기간 | 주요 변경 내용 |
| --- | --- | --- |
| V1.0 | 2025.09.02 ~ 2025.09.17 | • 로그인 기능 구현<br>• 클래스 목록 조회 및 카테고리 필터링<br>• 클래스 상세 정보 조회<br>• 댓글 CRUD 기능 구현<br>• 좋아요 기능 구현<br>• 검색 기능 구현 |

<a id="tech-stack"></a>
## ⚙️ 기술스택

### 개발환경

| 구분 | 비고 |
|-------------|--------------------------------------|
| Swift 5.0 | iOS 앱 개발을 위한 프로그래밍 언어 |
| iOS 16.0+ | Minimum Deployment Target |
| Xcode 15.0+ | 통합 개발 환경 |

### 사용 패턴

| 구분 | 패턴 | 비고 |
|-------------|-------------------------------------|------|
| 아키텍처 | MVVM + Input/Output Pattern | • ViewModel의 transform 메서드를 통한 Input → Output 단방향 데이터 흐름<br>• RxSwift를 활용한 반응형 데이터 바인딩<br>• 비즈니스 로직과 UI 완전 분리 |
| 디자인 패턴 | Singleton Pattern | • 전역 매니저 클래스 (NetworkManager 등) |
| 프로토콜 지향 | ViewModelProtocol, ReusableViewProtocol | • Input/Output 구조를 강제하는 프로토콜 기반 설계<br>• Cell 재사용 식별자 자동화 |

### UI 구성

| 구분 | 비고 |
|---------|----------------------------------------------------|
| UIKit | iOS 기본 UI 프레임워크 |
| [SnapKit 5.7.1](https://github.com/SnapKit/SnapKit) | Auto Layout을 간결하게 작성할 수 있는 DSL |
| [Toast-Swift](https://github.com/scalessec/Toast-Swift) | 토스트 메시지 UI |

### 네트워크

| 구분 | 비고 |
|--------|-------------------------------------|
| [Alamofire 5.0+](https://github.com/Alamofire/Alamofire) | HTTP 네트워크 통신 라이브러리 |

### 반응형 프로그래밍

| 구분 | 비고 |
|--------------------------------|---------------------------------------------------------------------|
| [RxSwift 6.0+](https://github.com/ReactiveX/RxSwift) | 반응형 프로그래밍을 통한 비동기 이벤트 처리 |
| [RxCocoa 6.0+](https://github.com/ReactiveX/RxSwift) | UIKit과 RxSwift 바인딩 |
| [RxGesture](https://github.com/RxSwiftCommunity/RxGesture) | 제스처 이벤트 RxSwift 바인딩 |

### 이미지 처리

| 구분 | 비고 |
|--------|-------------------------------------|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | 비동기 이미지 다운로드 및 캐싱 라이브러리 |

<a id="tech-decision"></a>
## 🧠 기술적 의사결정

### 1. Router 패턴을 통한 API 엔드포인트 관리

**구현 이유**
- API 엔드포인트의 체계적 관리 및 코드 가독성 향상
- 중복 코드 제거 및 유지보수성 향상
- HTTP Method, Header, Parameter 등 네트워크 요청 로직 표준화

**구현 방법**
```swift
// Router.swift
enum Router {
    case login(email: String, pw: String)
    case classCheck
    case classDetail(classId: String)
    case classSearch(title: String)
    case commentEdit(classId: String, editString: String)
    case commentSearch(classId: String)
    case commentRevise(classId: String, commentId: String, content: String)
    case commentDelete(classId: String, commentId: String)
    case likeClass(classId: String, likeStatus: Bool)

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .classCheck, .classDetail, .classSearch, .commentSearch: return .get
        case .commentEdit, .likeClass: return .post
        case .commentRevise: return .put
        case .commentDelete: return .delete
        }
    }

    var header: HTTPHeaders {
        guard let headerKey = Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String
        else { return .init() }

        let token = UserDefaults.standard.string(forKey: "token")

        var defaultHeader: HTTPHeaders = [
            "SesacKey": headerKey,
            "Content-Type": "application/json"
        ]

        if let token {
            defaultHeader.add(name: "Authorization", value: token)
        }

        return defaultHeader
    }

    var encodingType: ParameterEncoding {
        switch self {
        case .login, .commentRevise, .likeClass, .commentEdit:
            return JSONEncoding.default
        case .classCheck, .classSearch, .classDetail, .commentSearch, .commentDelete:
            return URLEncoding.default
        }
    }
}
```

**효과**
- API 요청 관련 코드 중앙화
- 엔드포인트 변경 시 한 곳만 수정
- HTTP Method, Encoding 방식 자동 처리
- Authorization 토큰 자동 헤더 추가

---

### 2. Generic + Result 타입을 활용한 네트워크 레이어 추상화

**구현 이유**
- 네트워크 요청 로직 재사용성 극대화
- 다양한 응답 타입 처리를 위한 유연한 구조
- 세밀한 에러 핸들링 (인터넷 연결, 서버 에러, 디코딩 에러 등)

**구현 방법**
```swift
// NetworkManager.swift
final class NetworkManager {
    static let shared = NetworkManager()

    func fetchData<T: Decodable>(
        router: Router,
        type: T.Type
    ) -> Single<Result<T, CustomNetworkError>> {
        return Single.create { value in
            AF.request(router.endPoint,
                       method: router.method,
                       parameters: router.parameter,
                       encoding: router.encodingType,
                       headers: router.header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { responseData in
                switch responseData.result {
                case .success(let data):
                    value(.success(.success(data)))
                case .failure(let error):
                    // 인터넷 연결 에러
                    if let urlError = error.underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            value(.success(.failure(.noInternet)))
                        default:
                            value(.success(.failure(.unknown)))
                        }
                        return
                    }

                    // 서버 에러 메시지 디코딩
                    if let data = responseData.data,
                       let decodedData = try? JSONDecoder().decode(ServerError.self, from: data) {
                        value(.success(.failure(.serverError(message: decodedData.message))))
                        return
                    }

                    value(.success(.failure(.decodingError)))
                }
            }
            return Disposables.create()
        }
    }
}

// CustomNetworkError.swift
enum CustomNetworkError: Error {
    case noInternet
    case serverError(message: String)
    case decodingError
    case unknown

    var errorMessage: String {
        switch self {
        case .noInternet: return "인터넷 연결을 확인해주세요"
        case .serverError(let message): return message
        case .decodingError: return "데이터 처리 중 오류가 발생했습니다"
        case .unknown: return "알 수 없는 오류가 발생했습니다"
        }
    }
}
```

**효과**
- 모든 API 요청에서 재사용 가능한 네트워크 레이어
- Result 타입을 통한 명확한 성공/실패 처리
- 에러 타입별 맞춤 메시지 제공
- RxSwift Single Traits를 사용한 일회성 요청 처리

---

### 3. DTO 패턴 및 Extension을 통한 데이터 변환 로직 분리

**구현 이유**
- 서버 응답 모델과 앱 내부 모델 분리
- API 응답 변경 시 영향 범위 최소화
- 데이터 가공 로직(가격 포맷팅, URL 조합, 할인율 계산 등)을 Extension으로 분리

**구현 방법**
```swift
// ClassCheckDTO.swift - 서버 응답 모델
struct DataDTO: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let imageUrl: String
    let createdAt: String
    let isLiked: Bool
    let creator: CreatorDTO

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case salePrice = "sale_price"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        // ... 기타
    }

    func toDomain() -> ClassCheck {
        return .init(
            classId: classId,
            categoryTitle: categoryTitle,
            category: category,
            title: title,
            description: description,
            price: bindPrice,
            priceValue: price ?? 0,
            salePrice: bindSalePrice,
            createdAt: createdAt,
            imageUrl: bindImageUrl,
            persent: persent,
            isLiked: isLiked,
            creator: creator
        )
    }
}

extension DataDTO {
    var bindImageUrl: URL? {
        return URL(string: BaseURL.url + "/v1" + imageUrl)
    }

    var categoryTitle: String {
        return CategoryTitle(rawValue: category)?.title ?? ""
    }

    var bindSalePrice: String {
        guard let salePrice else { return "무료" }
        return salePrice.demical  // Int Extension: "10,000원"
    }

    var bindPrice: String {
        guard let price else { return "무료" }
        return price.demical
    }

    var persent: String {
        if let price, let salePrice {
            return "\((salePrice * 100) / price)%"
        }
        return ""
    }
}

// ClassCheck.swift - 도메인 모델
struct ClassCheck {
    let classId: String
    let categoryTitle: String
    let category: Int  // UI 미사용: 필터링용
    let title: String
    let description: String
    let price: String  // 이미 포맷팅된 문자열
    let priceValue: Int  // UI 미사용: 정렬용
    let salePrice: String
    let createdAt: String  // UI 미사용: 정렬용
    let imageUrl: URL?
    let persent: String  // 할인율
    let isLiked: Bool
    let creator: CreatorDTO
}
```

**효과**
- 서버 응답 snake_case → camelCase 자동 변환
- 가격 포맷팅, URL 조합, 할인율 계산 로직 DTO Extension으로 캡슐화
- UI에 필요한 형태로 가공된 데이터만 도메인 모델에 포함
- 정렬/필터링용 원본 데이터는 UI에 노출하지 않음

---

### 4. Set을 활용한 다중 카테고리 필터링 최적화

**구현 이유**
- 여러 카테고리 동시 선택 가능
- O(1) 시간 복잡도로 카테고리 포함 여부 확인
- 중복 없는 카테고리 관리

**구현 방법**
```swift
// ClassCheckViewModel.swift
struct State {
    let totalData: BehaviorRelay<[ClassCheck]>
    var currentCategories: Set<Int>  // Set 자료구조 사용
}

// 카테고리 선택 로직
input.selectedCategory
    .bind(with: self) { owner, category in
        if category == 0 {  // 전체 선택
            state.currentCategories.removeAll()
            state.currentCategories.insert(0)
            selectedData.accept(state.totalData.value)
        } else {
            if state.currentCategories.contains(0) {
                state.currentCategories.removeAll()
            }

            if state.currentCategories.contains(category) {
                // 이미 선택된 카테고리 제거
                state.currentCategories.remove(category)
                let data = selectedData.value.filter { $0.category != category }
                selectedData.accept(data)

                // 선택된 카테고리가 없으면 전체로 복귀
                if state.currentCategories.count == 0 {
                    state.currentCategories.insert(0)
                    selectedData.accept(state.totalData.value)
                }
            } else {
                // 새 카테고리 추가
                state.currentCategories.insert(category)
                let totalData = state.totalData.value
                let data = totalData.filter { state.currentCategories.contains($0.category) }
                selectedData.accept(data)
            }
        }
    }
```

**효과**
- 다중 카테고리 선택 UI/UX 구현
- Set의 O(1) 검색 성능으로 빠른 필터링
- 전체 선택 시 자동으로 개별 카테고리 해제

---

### 5. 공백 제외 글자 수 카운팅을 통한 댓글 유효성 검증

**구현 이유**
- 공백만 입력하여 빈 댓글 작성 방지
- 실질적인 텍스트 길이 기반 유효성 검증
- 150자 이상 시 시각적 경고

**구현 방법**
```swift
// CommentEditViewModel.swift
private func getOnlyTextCount(_ text: String) -> Int {
    let split = text.split(separator: " ")
    return split.joined().count
}

// 글자 수 표시
textField
    .map { owner, value in
        if value.count > CommentLimit.maxCount.rawValue {
            return "\(CommentLimit.maxCount.rawValue)자 초과"
        }
        let onlyTextCount = owner.getOnlyTextCount(value)
        return "\(onlyTextCount) / \(CommentLimit.maxCount.rawValue)"
    }
    .bind(to: textCount)

// 텍스트 색상 변경 (150자 이상 빨간색)
textField
    .map { owner, value in
        owner.getOnlyTextCount(value)
    }
    .map { value in
        if value >= CommentLimit.middleCount.rawValue && value <= CommentLimit.maxCount.rawValue {
            return "red"
        }
        return "black"
    }
    .bind(to: textColor)

// 저장 버튼 활성화 (2자 이상 200자 이하)
textField
    .map { owner, value in
        owner.getOnlyTextCount(value)
    }
    .map { !($0 < CommentLimit.minCount.rawValue || $0 > CommentLimit.maxCount.rawValue) }
    .bind(to: saveButtonState)

enum CommentLimit: Int {
    case minCount = 2
    case middleCount = 150
    case maxCount = 200
}
```

**효과**
- 공백만 입력한 빈 댓글 차단
- 150자 이상 시 빨간색 경고로 시각적 피드백
- 2~200자 범위 외 입력 시 저장 버튼 비활성화

---

### 6. NotificationCenter를 통한 화면 간 데이터 동기화

**구현 이유**
- 댓글 작성/수정/삭제 후 이전 화면의 댓글 개수 실시간 업데이트
- ViewModel 간 직접 의존성 제거
- 느슨한 결합으로 유지보수성 향상

**구현 방법**
```swift
// ClassDetailViewModel.swift
NotificationCenter.default.rx.notification(Notification.Name("commentPop"), object: nil)
    .withUnretained(self)
    .flatMap { owner, value in
        owner.networkManager.fetchData(
            router: .commentSearch(classId: owner.classData.classId),
            type: Comment.self
        )
    }
    .bind(with: self) { owner, responseData in
        switch responseData {
        case .success(let value):
            commentCount.accept(Message.showComment(value.data.count).title)
        case .failure(let error):
            errorMessage.accept(error.errorMessage)
        }
    }
    .disposed(by: disposeBag)

// CommentEditViewController.swift - 댓글 작성 완료 시
navigationController?.popViewController(animated: true)
NotificationCenter.default.post(name: NSNotification.Name("commentPop"), object: nil)
```

**효과**
- 댓글 화면에서 작성/수정/삭제 후 상세 화면의 댓글 개수 자동 업데이트
- Delegate 패턴 대비 간결한 코드
- 여러 옵저버 동시 구독 가능

---

### 7. Kingfisher를 활용한 이미지 캐싱 및 최적화

**구현 이유**
- 네트워크 트래픽 절감
- 이미지 로딩 성능 향상
- 메모리 관리 자동화

**구현 방법**
```swift
// KingfisherManager+Extension.swift
import Kingfisher

extension KingfisherManager {
    static func setImage(with urlString: String?, to imageView: UIImageView, placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            imageView.image = placeholder
            return
        }

        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
```

**효과**
- 자동 메모리/디스크 캐싱
- 네트워크 요청 중복 제거
- 부드러운 이미지 로딩 UX (Fade 애니메이션)

<a id="project-structure"></a>
## 📂 프로젝트 구조

```
HaeraClass/
├── App/
│   ├── AppDelegate.swift              # 앱 생명주기
│   ├── SceneDelegate.swift            # Scene 관리
│   └── Info.plist                     # 앱 설정
│
├── Login/                             # 로그인
│   ├── LoginViewController.swift
│   └── LoginViewModel.swift
│
├── ClassCheck/                        # 클래스 목록
│   ├── ClassCheckViewController.swift
│   ├── ClassCheckViewModel.swift
│   ├── Model/
│   │   ├── ClassCheck.swift           # 도메인 모델
│   │   └── ClassCheckDTO.swift        # DTO 및 변환 로직
│   └── View/
│       ├── ClassCategoryTableViewCell.swift
│       ├── ClassCategoryCell.swift
│       └── SortButton.swift
│
├── ClassDetail/                       # 클래스 상세
│   ├── ClassDetailViewController.swift
│   ├── ClassDetailViewModel.swift
│   ├── Model/
│   │   ├── ClassDetail.swift
│   │   ├── ClassDetailDTO.swift
│   │   └── Comment.swift
│   └── View/
│       ├── DetailPhotoCell.swift
│       └── ClassInfoView.swift
│
├── ClassComment/                      # 댓글 목록
│   ├── ClassCommentViewController.swift
│   ├── ClassCommentViewModel.swift
│   └── View/
│       └── CommentCell.swift
│
├── CommentEdit/                       # 댓글 작성/수정
│   ├── CommentEditViewController.swift
│   └── CommentEditViewModel.swift
│
├── ClassSearch/                       # 클래스 검색
│   ├── ClassSearchViewController.swift
│   ├── ClassSearchViewModel.swift
│   └── View/
│       └── ClassSearchCell.swift
│
├── Setting/                           # 설정
│   ├── SettingViewController.swift
│   └── SettingViewModel.swift
│
├── Secret/                            # API 설정
│   └── BaseURL.swift
│
└── Common/                            # 공통 모듈
    ├── Base/                          # Base 클래스
    │   ├── BaseViewController.swift
    │   ├── BaseTableViewCell.swift
    │   └── BaseCollectionViewCell.swift
    ├── Network/                       # 네트워크
    │   ├── NetworkManager.swift
    │   ├── Router.swift
    │   └── CustomNetworkError.swift
    ├── Model/                         # 공통 모델
    │   ├── ClassData.swift
    │   ├── ClassDTO.swift
    │   ├── Login.swift
    │   ├── Like.swift
    │   └── ServerError.swift
    ├── Protocol/                      # 프로토콜
    │   ├── ViewModelProtocol.swift
    │   └── ReusableViewProtocol.swift
    ├── Extension/                     # Extension
    │   ├── UIColor+Extension.swift
    │   ├── UITextField+Extension.swift
    │   ├── Int+Extension.swift
    │   ├── KingfisherManager+Extension.swift
    │   └── KingfisherWrapper+Extension.swift
    ├── Design/                        # 디자인 시스템
    │   ├── ColorSet.swift
    │   └── ImageSet.swift
    ├── View/                          # 공통 뷰
    │   ├── TabBarController.swift
    │   └── OrangePointButton.swift
    ├── Util/                          # 유틸리티
    │   ├── AlertManager.swift
    │   ├── DateManager.swift
    │   └── NumberManager.swift
    ├── Temp/                          # 로컬 데이터
    │   ├── TotalDataManager.swift
    │   └── CommentDataManager.swift
    └── Etc/
        └── CategoryTitle.swift
```

<a id="sample-images"></a>
## 📸 샘플 이미지

| 화면 | 주요 기능 |
|:---:|:---|
| **로그인**<br><img src="https://github.com/user-attachments/assets/7771cec4-278b-46c1-9dba-1aad5177233e" width="300" alt="로그인" /> | - 이메일/비밀번호 입력<br>- 유효성 검증 실시간 피드백<br>- 자동 로그인 지원 |
| **클래스 목록**<br><img src="https://github.com/user-attachments/assets/e919e68e-c42f-4fad-ad1c-40d3483b9e79" width="300" alt="클래스 목록" /> | - 카테고리별 다중 필터링<br>- 최신순/가격순 정렬 토글<br>- 할인율 및 가격 정보 표시<br>- 찜 기능 (하트 아이콘) |
| **클래스 상세**<br><img src="https://github.com/user-attachments/assets/baf55e22-698f-4260-a045-af21c8d720f4" width="300" alt="클래스 상세" /> | - 이미지 슬라이더 (페이징)<br>- 강사 정보 및 클래스 상세 정보<br>- 좋아요 토글 및 댓글 개수 표시 |
| **댓글 조회**<br><img src="https://github.com/user-attachments/assets/17bdd180-e65f-451a-b2a1-f53b36a7ad4d" width="300" alt="댓글 조회" /> | - 댓글 목록 조회<br>- 본인이 작성한 댓글 수정/삭제 가능 |
| **댓글 입력**<br><img src="https://github.com/user-attachments/assets/59e79d6e-abd1-4f6b-a8dd-e0361971b73d" width="300" alt="댓글 입력" /> | - 공백 제외 글자 수 카운팅<br>- 150자 이상 시 빨간색 경고<br>- 2~200자 범위 유효성 검증 |

---
