import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/components/back_icon.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final bool isProfileScreen;

  const PrivacyPolicyScreen({
    Key? key,
    required this.isProfileScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Terms_Privacy',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "개인정보 처리방침",
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: isProfileScreen
              ? BackIcon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: [
            isProfileScreen
                ? Container()
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
          ],
          automaticallyImplyLeading: isProfileScreen ? true : false,
        ),
        body: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 4.0,
            radius: const Radius.circular(8.0),
            child: Markdown(
              data: '''
<하루냥>은 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다. 하루냥은 개인정보처리방침을 개정하는 경우 애플리케이션 내 공지를 통하여 공지할 것입니다.

## 개인정보처리방침 총칙

### 1. 처리하는 개인정보의 항목 및 처리 목적

하루냥은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전 동의를 구할 예정입니다.

- 서비스 제공
콘텐츠 제공 등을 목적으로 개인정보를 처리합니다.
- 마케팅 및 광고에 활용
맞춤 서비스 제공, 이벤트 알림 등을 목적으로 개인정보를 처리합니다.

### 2. 개인정보 수집 및 이용 내역

하루냥이 회원가입 이후 이용자로부터 수집하는 개인정보 내역은 다음과 같습니다.

1. 카카오 계정 연동 회원가입 
    - 필수 항목 : 이용자 고유 식별자
    - 선택 항목 : 이메일 주소
2. 이용자가 이용 정보
    - 일기 본문, 기록한 기분 및 강도
    - 서비스 이용 기록, 접속로그
    - 수집방법 : 애플리케이션 내의 일기 작성 화면, 회원가입 화면

### 3. 개인정보의 처리 및 보유 기간

1. 하루냥은 법령에 따른 개인정보 보유, 이용 기간 또는 정보 주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유, 이용 기간 내에서 개인정보를 처리, 보유합니다.
2. 개인정보 처리 및 보유 기간은 다음과 같습니다.
    - 보유근거 : 개인화된 서비스 제공 / 고객 지원 및 피드백 제공
    - 보유기간 : 회원탈퇴 및 이용기간 종료시까지 (단, 법령 위반에 따른 수사, 조사 등이 진행중인 경우에는 해당 수사, 조사 종료 시 까지 보관하며 내부규정 혹은 관련법령에 따라 일정기간동안 보관됨)

### 4. 정보 주체와 법정대리인의 권리, 의무 및 그 행사방법

이용자는 개인정보 주체로써 다음과 같은 권리를 행사할 수 있습니다.

1. 정보 주체는 하루냥에 대해 언제든지 개인정보 열람, 정정, 삭제, 처리 정지 요구 등의 권리를 행사할 수 있습니다.
2. 제 1항에 따른 권리 행사는 하루냥에 대해 개인정보 보호법 시행령 제 41조 제 1항에 따라 서면, 전자우편 등을 통하여 하실 수 있으며 하루냥은 이에 대해 지체 없이 조치하겠습니다.
3. 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제 11호 서식에 따른 위임장을 제출하셔야 합니다.
4. 개인정보 열람 및 처리 정지 요구는 개인정보보호법 제 35조 제 5항, 제 37조 제 2항에 의하여 정보 주체의 권리가 제한될 수 있습니다.
5. 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.
6. 하루냥은 정보주체 권리에 따른 열람의 요구, 정정, 삭제의 요구, 처리 정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.

### 5. 개인정보 제 3자 제공

하루냥은 이용자 동의 없이 개인정보를 제 3자에게 제공하지 않습니다. 단, 아래 경우에는 예외로 합니다.

- 개인정보보호법 등 관계 법령이 정하는 경우
- 수사 또는 조사 기관의 요청이 있는 경우
- 보유기간 : 서비스 제공 기간 (단, 관련법령에 정해진 규정이 있을 시 해당 보유기간 동안 보관하며 목적 달성 시 즉시 파기합니다)

### 6. 개인정보의 파기

하루냥은 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

- 파기절차
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장 후 혹은 즉시 파기됩니다. 이때 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.
- 파기기한
이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.
- 파기방법
전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.

### 7. 개인정보 보호책임자 작성

1. 하루냥은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
    - 성명 : 김민철
    - 직책 : 팀 PM
    - 연락처 : [dangdangss04@gmail.com](mailto:dangdangss04@gmail.com)
2. 정보주체께서는 하루냥의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 하루냥은 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

### 8. 개인정보 처리 방침 변경

1. 이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경 내용의 추가, 삭제 및 정정이 있는 경우에는 변경 사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.

### 9. 개인정보의 안전성 확보 조치

하루냥은 개인정보보호법 제 29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

1. 개인정보 취급 직원의 최소화 및 교육
개인정보를 취급하는 직원을 지정하고 담당자에  한정시켜 최소화하여 개인정보를 관리하는 대책을 시행하고 있습니다.
2. 개인정보의 암호화
이용자의 개인정보는 암호화 되어 저장 및 관리되고 있어 본인만이 알 수 있습니다.
3. 개인정보에 대한 접근 제한
개인정보를 처리하는 DB 시스템에 대한 접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근통제를 위한 필요 조치를 하고 있습니다.

### 10. 정보주체의 권익 침해에 대한 구제 방법

개인정보 침해에 대한 신고나 상담이 필요한 경우에는 아래 기관에 문의 가능합니다.

- 개인정보침해 신고센터 / (국번없이)118 / [https://privacy.kisa.or.kr](https://privacy.kisa.or.kr)
- 개인정보 분쟁조정위원회 / (국번없이) 1833-6972 / [https://www.kopico.go.kr](https://www.kopico.go.kr)
- 대검찰청 사이버범죄수사단 / (국번없이) 1301 / [https://www.spo.go.kr](https://www.spo.go.kr)
- 경찰청 / (국번없이) 182 / [https://ecrm.cyber.go.kr](https://ecrm.go.kr)

[개인정보보호법]제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.

※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회([www.simpan.go.kr](http://www.simpan.go.kr/)) 홈페이지를 참고하시기 바랍니다.

## 모바일 애플리케이션 개인정보 정책

### 1. 백업

정기적으로 데이터를 백업할 것을 권장합니다.

### 2. 데이터 분석

애플리케이션은 사용자의 동의 없이 사용 또는 충돌 보고 데이터를 수집하지 않습니다. 데이터 수집에 동의한 경우 애플리케이션은 서비스를 제공하고, 사용자의 요구를 이해하고, 서비스 개선에 필요한 일부 사용자 데이터를 수집합니다. 앱 시작, 탭, 클릭, 스크롤 정보, 화면 방문, 세션 기간 또는 귀하가 당사 앱과 상호 작용하는 방법에 대한 기타 정보와 같은 데이터는 암호화되어 집계됩니다. 데이터 수집에 동의한 경우 애플리케이션은 앱의 안정성과 성능을 개선할 수 있도록 충돌 및 성능 보고서도 수집합니다. 

### 3. 사진

사용자의 선택에 따라 애플리케이션에 사진을 첨부할 수 있습니다. 다른 사용자는 사진에 접근할 수 없습니다.

### 4. Android

Android 앱에 대해 다음과 같은 타사 서비스를 사용합니다.

Firebase용 Google 애널리틱스(Google Inc.) 

- 이 서비스는 사용 패턴을 이해하고 Android 애플리케이션을 개선하기 위해 사용 데이터를 수집하고 분석하는데 도움이 됩니다.
- 수집된 데이터 : 쿠키, 고유 기기 식별자, Android 광고 ID, Firebase 설치 ID, 애널리틱스 앱 인스턴스 ID, 사용 데이터, 익명 처리된 IP 주소, 세션 시간, 기기 모델, 운영체제, 지역, 인앱과같은 다양한 사용 및 기기 데이터 구매, 최초 실행, 앱 열기, 앱 업데이트
- 데이터 보존 : 3년

Firebase Crashlytics (Google Inc.)

- 이 서비스는 앱에서 충돌 및 오류를 식별, Android 앱의 안정성을 개선하는데 도움이 됩니다.
- 수집된 데이터 : Crashlytics 설치 UUID, 충돌 추적, 기기 모델, 지역, 운영체제
- 데이터 보존 : 90일

### 5. iOS

iOS 애플리케이션에 대해 다음과 같은 타사 서비스를 사용합니다.

Firebase용 Google 애널리틱스(Google Inc.)

- 이 서비스는 사용 패턴을 이해하고 iOS 애플리케이션을 개선하기 위해 사용 데이터를 수집하고 분석하는데 도움이 됩니다.
- 수집된 데이터 : 다양한 사용 데이터, Firebase 설치 ID, 애널리틱스 앱 인스턴스 ID, 익명 처리된 IP 주소, 세션 시간, 기기 모델, 운영체제, 지역, 인앱 구매, 최초 실행, 앱 열기, 앱 업데이트
- 데이터 보존 : 3년

Firebase Crashlytics (Google Inc.)

- 이 서비스는 앱에서 충돌 및 오류를 식별, iOS 앱의 안정성을 개선하는데 도움이 됩니다.
- 수집된 데이터 : Crashlytics 설치 UUID, 충돌 추적, 기기 모델, 지역, 운영체제
- 데이터 보존 : 90일

### 6. 광고

광고는 앱을 무료로 유지하는데 도움이 됩니다. 광고 내용은 사용자의 항목이나 메모를 기반으로 하지 않습니다. 사용자의 데이터는 광고 제공 업체와 공유하지 않습니다. 광고 컨텐츠는 Admob(Admob Google Inc.) 서비스를 사용합니다. Admob을 사용하여 사용자의 관심사에 따라 광고 배너 및 기타 광고를 표시합니다. Admob은 쿠키를 사용하여 사용자를 식별하고 리타게팅 기술을 사용할 수 있습니다. Google의 광고 요구 사항은 Google의 광고 원칙 (https://google.com/policies/privacy/partners/)에 의해 요약될 수 있습니다. 

- 수집되는 항목 : 쿠키, Google 광고주 ID

### 7. 갱신

단체는 본 정책을 수정하거나 교체할 수 있습니다. 향후 개인 정보 보호 정책에 대한 변경 사항은 이 페이지에 게시됩니다.

### 8. 문의

하루냥 애플리케이션을 사용하는 동안 개인 정보 보호에 대해 질문이 있으실 경우 [dangdangss04@gmail.com](mailto:dangdangss04@gmail.com)을 통해 문의해주세요.

이 약관은 2023년 1월 29일에 업데이트 되었습니다.

---

# Copyright © 하루냥. All rights reserved.
''',
              styleSheet: MarkdownStyleSheet(
                h1: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                h1Align: WrapAlignment.center,
                h2: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                h2Padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                h3: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                h3Padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                h4: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                p: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.border,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}