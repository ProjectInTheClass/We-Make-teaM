//각 일정에 대한 제출현황
import SwiftUI

struct SubmitView: View {
    var event: CustomEvent // 특정 이벤트를 전달받음
    @State private var members: [Member] = [
        Member(name: "김현경", hasSubmitted: true),
        Member(name: "신준용", hasSubmitted: false),
        Member(name: "정광석", hasSubmitted: true)
    ]
    
    var body: some View {
        VStack {
            Text(event.title)
                .font(.largeTitle)
                .padding()
            
            Text("날짜: \(event.date, formatter: dateFormatter)")
                .padding(.bottom, 10)
            Text("장소: \(event.location)")
                .padding(.bottom, 20)

            List(members) { member in
                NavigationLink(destination: member.hasSubmitted ? MemberSubmissionDetailView(member: member) : nil) {
                    HStack {
                        Text(member.name)
                            .font(.headline)
                        Spacer()
                        Text(member.hasSubmitted ? "제출 O" : "제출 X")
                            .foregroundColor(member.hasSubmitted ? .green : .red)
                    }
                }
                .disabled(!member.hasSubmitted)
            }
            .listStyle(PlainListStyle())

            Spacer()

            Button(action: {
                // 과제 제출 페이지로 이동하는 동작 추가 (예: MySubmissionView())
                print("과제 제출 페이지로 이동")
            }) {
                Text("과제 제출하러 가기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }
        }
        .padding()
        .navigationTitle("제출 현황")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct Member: Identifiable {
    let id = UUID()
    let name: String
    let hasSubmitted: Bool
}

#Preview {
    SubmitView(event: CustomEvent(title: "디자인 중간 발표", date: Date(), location: "잇힛 507호", color: .red, participants: ["A", "B"]))
}

