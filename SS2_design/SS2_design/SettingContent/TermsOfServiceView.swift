import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SectionDetailView(title: "이용약관", content: """
                    이 앱의 이용약관에 오신 것을 환영합니다.

                    1. **서비스 이용**  
                    사용자는 본 서비스를 정당한 목적으로만 이용할 수 있습니다.

                    2. **개인정보 보호**  
                    사용자의 개인정보는 철저히 보호되며, 이용약관에 명시된 목적 외에는 사용되지 않습니다.

                    3. **금지사항**  
                    불법적인 활동, 타인의 권리를 침해하는 행위, 또는 시스템의 무단 접근은 엄격히 금지됩니다.

                    4. **책임 한계**  
                    서비스는 현 상태 그대로 제공되며, 서비스 이용에 따른 손해에 대해 회사는 책임을 지지 않습니다.

                    자세한 내용은 고객센터를 통해 문의해주세요.
                """)) {
                    Text("이용약관")
                }

                NavigationLink(destination: SectionDetailView(title: "개인정보 처리방침", content: """
                    개인정보 처리방침에 대한 내용입니다.

                    1. **수집하는 개인정보 항목**  
                    - 이름, 이메일, 연락처 등.

                    2. **개인정보의 수집 및 이용 목적**  
                    - 회원 관리, 서비스 제공, 고객 응대.

                    3. **개인정보의 보유 및 이용 기간**  
                    - 회원 탈퇴 시 즉시 삭제.

                    4. **개인정보 보호**  
                    - 데이터 암호화 및 보안 조치를 통해 사용자의 개인정보를 보호합니다.

                    더 자세한 내용은 별도의 문의를 통해 확인해주세요.
                """)) {
                    Text("개인정보 처리방침")
                }

                NavigationLink(destination: SectionDetailView(title: "어플 정책", content: """
                    어플 정책에 대한 안내입니다.

                    1. **사용 제한**  
                    - 어플의 무단 복제 및 배포는 금지됩니다.

                    2. **업데이트 정책**  
                    - 정기적으로 업데이트를 통해 새로운 기능과 보안 패치를 제공합니다.

                    3. **피드백 및 개선**  
                    - 사용자의 피드백을 적극 반영하여 더 나은 서비스를 제공합니다.

                    4. **서비스 중단**  
                    - 예고 없이 서비스를 중단할 수 있으며, 이는 회사의 재량에 따라 결정됩니다.

                    어플 정책은 지속적으로 개선되며, 새로운 정책은 공지사항을 통해 안내됩니다.
                """)) {
                    Text("어플 정책")
                }
            }
            .navigationTitle("이용약관 및 정책")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 섹션 세부 내용 뷰
struct SectionDetailView: View {
    let title: String
    let content: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Text(content)
                    .font(.body)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TermsOfServiceView()
}

