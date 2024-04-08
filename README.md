# HaruNyang front Documentation

### 프로젝트 설명

일기를 작성하면 일기의 단어를 매칭하여 편지 또는 명대사를 추천해주는 일기 앱입니다.

<img src="https://user-images.githubusercontent.com/73716178/222867930-be759be5-1876-409c-b973-1c22e6ef5497.png" width="500" height="1000"/>

### 사용중인 상태관리, 디자인 패턴

Getx 상태관리 패키지를 사용하며 클린 아키텍쳐 패턴중 하나인 mvvm 디자인 패턴을 채택하여 프로젝트를 구성 할 계획입니다.

![0_zUtZYiJ1bDTugOYY](https://user-images.githubusercontent.com/73716178/201530142-9a2df361-6c7d-4898-94e9-3cd5880118df.png)

# 프로젝트 구성 안내

- Flutter version 3.3.1
- Dart version 2.18.0
- DevTools version 2.15.0
- Android SDK version 33.0.0

`flutter doctor -v` 로 현재 사용중인 프로젝트의 개발환경 확인이 가능합니다.

## 프로젝트 Clone

[https://github.com/beside04/frontend](https://github.com/beside04/frontend)

해당 프로젝트 clone 후,

`flutter pub get`로 플러그인들을 사용할 수 있게 프로젝트로 가져와서 사용 하시면 됩니다.

## 빌드 방법

### apk 추출

- `flutter build apk` 를 통해 apk를 추출 할 수 있습니다.
- 추출 후 `build/app/outputs/apk/release` 에서 추출된 apk 확인이 가능합니다.

### App Bundle 추출

- `flutter build appbundle` 를 통해 appbundle를 추출 할 수 있습니다.
- 추출 후 `build/app/outputs/bundle/release` 에서 추출된 appbundle 확인이 가능합니다.

## Git Flow Rules

- 기능/이니션-개발내용을 develop branch 기준으로 분기합니다.
    - ex ) feature/jgw-login-screen
- 한번 커밋은 하나의 기능 개발을 목표로 합니다.
- 상대방에게 코드리뷰를 부탁하고 develop branch 로 merge 합니다.
    - 개인 branch 에서 develop branch 로는 squash merge
    - develop branch 에서 master branch 는 create merge 를 합니다.

# C**ode Convention Rules**

Flutter에서는 코딩에 대한 구체적인 표준이나 규범을 정의하지 않고 있습니다. 하지만 Flutter는 Dart 언어를 사용하기에 되도록이면[Dart의 Coding Standard](https://dart.dev/guides/language/effective-dart/style)를 준수하여 작성하려고 합니다.

플러터 린트가 적용되어 있어 주로 자주 사용 하거나 주의해야할 부분만 추려 간단하게 정리했습니다. 자세한 내용은 [https://dart.dev/guides/language/effective-dart/style](https://dart.dev/guides/language/effective-dart/style) 해당 페이지에서 확인 가능합니다.

## Dart Code Convention

- **식별자 (Identifiers)**

Dart에서는 UppderCamelCase, lowerCamelCase, lowercase_with_underscores 네이밍 규칙을 사용합니다.

| UppderCamelCase (PascalCase)            | 모든 단어에서 첫 단어를 대문자로 시작하는 표기법입니다. 주로 클래스 이름에 사용합니다.                              |
|-----------------------------------------|--------------------------------------------------------------------------------|
| lowerCamelCase (camelCase)              | 소문자로 시작하며, 각 단어의 시작 문자를 대문자로 합니다. 주로 함수나 변수에 사용합니다.                            |
| lowercase_with_underscores (snake case) | 소문자만 사용하며 단어의 구분은 언더스코어(_)를 사용합니다. 대문자나 다른 구분자는 사용하지 않습니다. 주로 폴더명과 파일명에 사용합니다. |

### 1) **Type의 경우 UpperCamelCase를 사용합니다.**

Class, Enum, Typedef, Type 매개변수는 UpperCamelCase를 사용합니다.

```dart
class SliderMenu { ... }
class HttpRequest { ... }
typedef Predicate<T> = bool Function(T value);

...

class Foo {
  const Foo([arg]);
}
```

### 2) **소스파일, 디렉터리, 라이브러리, 패키지는 lowercase_with_underscores를 사용합니다.**

```dart
library peg_parser.source_scanner;

import 'package:flutter/material.dart';
import 'file_system.dart';
import 'slider_menu.dart';
```

### 3) **상수에는 lowerCamelCase 사용합니다.**

- enum 값을 포함하여 상수에는 lowerCamelCase를 사용해주세요.

```dart
//Good
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');
 
class Dice {
  static final numberGenerator = Random();
}

//Bad
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');
 
class Dice {
  static final NUMBER_GENERATOR = Random();
}
```

## Flutter Code Convention

### 1) 괄호를 닫을때 콤마(,)를 넣는거를 상시 해주세요.

- 닫는 괄호마다 콤마를 추가하여 들여쓰기를 해준다면 가독성이 올라갑니다.

### 2) 위젯간의 띄어쓰기와 주석은 최대한 줄이도록

- 주석을 넣더라도 위젯의 주석이나 바로 알 수 있는 함수의 주석은 넣을 필요는 없습니다. 오히려 코드의 가독성만 떨어지게 하는 원인이 될 수 있습니다.
- 주석은 최대한 줄이고 코드가 길어지거나 복잡도가 오를때, 코드의 의존성이 강해졌을때 사용하는 편이 좋을것 같습니다.
- 주석을 추가하면 해당 코드가 변경되는 순간 주석도 같이 관리해야하는 불편함과 코드보다 주석을 우선시 하게 보려는 심리 때문에 되도록 **주석 없이도 알 수 있는 코드를 작성하는게 좋을것 같습니다.**

### 3) 콤마가 있으면 항상 들여쓰기 넣기.

- 코드가 길어질때(파라미터의 갯수가 많을때)들여쓰기를 넣으면 한 줄로 있을때보다 가독성이 좋습니다.

### 4) 상대경로, 절대경로 하나로 통일 해주세요!

- 상대 경로와 절대 경로의 각자 취향이 있고 장단점이 존재하지만, 절대경로를 사용하면 **직관적으로 어디서 사용**하는지 알기가 쉽고, **수정이 용이**하여 저는 대부분 절대 경로를 사용하는 편입니다.

📌 그외 여러가지 있지만, 제일 중요한 두가지만 지키면 좋을 것 같습니다!

- **일관성을 최대한 유지**
- **가독성을 높이며 최대한 간단하게**

# **File Structure Rules**

### 1) Naming Convention (명명법)

- 폴더명과 파일명은 snake_case를 쓸 것
- 클래스명은 PascalCase를 쓸 것
- 변수명, 함수명은 camelCase를 쓸 것
- 클래스를 하나의 파일로 정리한다면 파일명과 클래스명은 동일하게 작성할 것ex) 파일명: login_screen.dart , 클래스명: LoginScreen
- 폴더명과 내부 파일의 역할이 정확한 분류라면 파일의 이름에 폴더명을 추가할 것(굳이 적지 않아도 명확히 특정 폴더 소속임이 명확하다면 파일 이름에 폴더명을 생략해도 좋다.)ex) 폴더명: screens, 파일명: login_screen.dart
- 폴더명은 복수형으로, 파일명은 단수형으로 작성할 것ex) 폴더명: screens, 파일명: login_screen.dart

### 2) **File Structure**

해당 디렉토리 구조는 클린 아키텍쳐 패턴중 하나인 MVVM 패턴의 사용되는 여러 구조의 자료를 찾아 적용했습니다.

![제목 없는 다이어그램 drawio (1)](https://user-images.githubusercontent.com/73716178/201528919-277f99a9-64e3-409e-afbb-ba8b8e000252.png)

⚠️ **어디까지나 참고로 작성한 내용이며, 작업중 불필요하다거나, 추가로 넣어야 한다면 수정이나 말씀 부탁드립니다! 🙏**

- config : 앱의 **전반적** 구성요소들입니다.
    - theme : theme 요소 및 theme 관리 데이터
    - route : 라우팅 소스
    - assets : images, logo 등의 앱에서 사용할 design asset
- core : 앱에서 **전역적**으로 사용되는 요소들입니다.
    - params : API 호출시 필요한 파라미터 모아둔 클래스
    - resources : API 호출시 결과를 갖는 wrapper class. 통신 성공/실패 케이스등
    - utils : 프로젝트의 모든 유틸리티 클래스
- data : data layer 관련 요소들
    - datasources : api 호출 클래스
        - local: 로컬에 저장된 정보를 가져오는 모든 함수들이 구현되어 있다.
        - remote: API서버와 통신에 필요한 모든 함수들이 구현되어 있다.
    - models : api 결과 데이터 관련 클래스(DTO)
    - repositories : api 클래스를 주입받아 사용하는 레포지토리 구현체
- domain : domain layer 관련 요소들
    - model : POJO (data폴더의 model과 달리 데이터 파싱, 변환에 영향을 받지않는 근본적인 데이터 구조를 나타내는 클래스)
    - repositories : api호출 인터페이스.
    - usecases : repository를 주입받아서 하나의 액션 수행하는 클래스 (비지니스 로직)
- presentation : presentation layer 관련 요소들
    - view : 사용자가 직접 확인이 가능한 하는 화면
        - component(widget) : 공통된 위젯 컴포넌트
    - viewmodel : View상태를 유지/관리하는 곳

