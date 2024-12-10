import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("이용약관 및 정책").font(.headline)) {
                    NavigationLink(destination: SectionDetailView(title: "서비스 이용약관", content: """
                        **서비스 이용약관**

                        **제1조 (목적)**  
                        본 약관은 [앱 이름] (이하 "회사")이 제공하는 서비스의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

                        **제2조 (약관의 효력 및 변경)**  
                        ① 본 약관은 서비스를 이용하는 모든 이용자에게 그 효력이 발생합니다.  
                        ② 회사는 필요한 경우 관련 법령을 위배하지 않는 범위 내에서 본 약관을 변경할 수 있습니다. 약관이 변경될 경우, 적용일자 및 변경사유를 명시하여 현행 약관과 함께 서비스 초기 화면에 그 적용일자 7일 전부터 공지합니다.

                        **제3조 (서비스의 제공 및 변경)**  
                        ① 회사는 이용자에게 다음과 같은 서비스를 제공합니다.  
                        - 사용자 계정 관리  
                        - 콘텐츠 업로드 및 공유  
                        - 실시간 채팅 및 커뮤니케이션  
                        - 기타 회사가 정하는 서비스

                        ② 회사는 서비스의 품질 향상을 위해 서비스의 내용을 변경할 수 있으며, 이 경우에는 사전에 공지합니다.

                        **제4조 (서비스 이용료 및 결제)**  
                        ① 회사는 일부 서비스에 대해 이용료를 부과할 수 있으며, 이용료는 별도의 안내를 통해 공지됩니다.  
                        ② 이용자는 서비스 이용료를 결제함으로써 본 약관에 동의한 것으로 간주됩니다.

                        **제5조 (이용자의 의무)**  
                        ① 이용자는 서비스 이용 시 다음 각 호의 행위를 하여서는 안 됩니다.  
                        - 타인의 개인정보를 도용하거나 무단으로 수집하는 행위  
                        - 서비스를 이용하여 법령이나 공서양속에 반하는 정보를 유포하는 행위  
                        - 회사의 서버 또는 네트워크에 과도한 부하를 주는 행위  
                        - 기타 불법적이거나 부당한 행위

                        **제6조 (서비스 이용의 제한 및 중지)**  
                        ① 회사는 이용자가 본 약관을 위반한 경우, 사전 통지 없이 서비스 이용을 제한하거나 중지할 수 있습니다.  
                        ② 회사는 시스템 점검, 고장, 기타 불가항력적인 사유로 인해 서비스의 제공을 일시적으로 중단할 수 있습니다.

                        **제7조 (저작권의 귀속 및 이용제한)**  
                        ① 서비스에 대한 저작권 및 지적재산권은 회사에 귀속됩니다.  
                        ② 이용자는 서비스를 이용함으로써 얻은 정보를 회사의 사전 동의 없이 복제, 전송, 출판, 배포, 방송 기타 방법으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.

                        **제8조 (면책 조항)**  
                        ① 회사는 천재지변, 불가항력적인 사유로 인해 서비스를 제공할 수 없는 경우 책임이 면제됩니다.  
                        ② 회사는 이용자가 서비스를 통해 기대하는 수익을 얻지 못하거나 상실한 데 대하여 책임을 지지 않습니다.

                        **제9조 (분쟁 해결)**  
                        본 약관과 서비스 이용과 관련하여 발생한 분쟁에 대하여는 대한민국 법을 적용합니다.  
                        분쟁이 발생한 경우, 회사와 이용자는 원만한 해결을 위해 노력합니다. 해결되지 않을 경우, 민사소송법에 따라 관할 법원에 소를 제기할 수 있습니다.

                        본 약관은 2024년 12월 10일부터 시행됩니다.
                    """)) {
                        HStack {
                           // Image(systemName: "doc.text")
                             //   .foregroundColor(.blue)
                            Text("서비스 이용약관")
                                .foregroundColor(.primary)
                        }
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
                        HStack {
                          //  Image(systemName: "lock.shield")
                            //    .foregroundColor(.green)
                            Text("개인정보 처리방침")
                                .foregroundColor(.primary)
                        }
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
                        HStack {
                            //Image(systemName: "gearshape")
                              //  .foregroundColor(.orange)
                            Text("어플 정책")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("이용약관 및 정책")
            .navigationBarTitleDisplayMode(.inline)
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

                    // Markdown을 지원하는 Text 뷰로 변경하여 포매팅
                    Text(content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    struct TermsOfServiceView_Previews: PreviewProvider {
        static var previews: some View {
            TermsOfServiceView()
        }
    }
}
