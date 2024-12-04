import SwiftUI

struct SubmitView: View {
    var event: Event // Specific event details
    var selectedDate: Date
    @State private var members: [Member] = [
        Member(name: "김현경", hasSubmitted: false),
        Member(name: "신준용", hasSubmitted: true),
        Member(name: "정광석", hasSubmitted: false)
    ]
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Text(event.title)
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading){
                Text("날짜: \(selectedDate, formatter: dateFormatter)")
                    .padding(.bottom, 10)
                Text("장소: \(event.location)")
                    .padding(.bottom, 20)
            }

            List(members) { member in
                NavigationLink(destination: member.hasSubmitted ? MemberSubmissionDetailView(member: member) : nil) {
                    HStack {
                        Text(member.name)
                            .font(.headline)
                        Spacer()
                        Text(member.hasSubmitted ? "제출 O" : "제출 X")
                            .fontWeight(.semibold)
                            .foregroundColor(member.hasSubmitted ? .yellow : .red)
                    }
                    .padding(5)
                    .padding(.bottom, 5)
                }
                .disabled(!member.hasSubmitted)
            }
            .listStyle(PlainListStyle())

            Spacer()

            NavigationLink(destination: UploadMySubmissionView(onSubmit: {
                if let myIndex = members.firstIndex(where: { $0.name == "김현경" }) {
                    members[myIndex].hasSubmitted = true
                }
            })) {
                Text("과제 제출하러 가기")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(width:300)
                    .background(Color.yellow.opacity(0.6))
                    .border(Color.gray, width: 1.3)
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
            }
        }
        .padding()
        .navigationTitle("제출 현황")
    }

}

struct Member: Identifiable {
    let id = UUID()
    let name: String
    var hasSubmitted: Bool
}

#Preview {
    SubmitView(event: Event(title: "디자인 중간 발표", date: Date(), location: "잇빗 507호", color: .red, participants: ["A", "B"]), selectedDate: Date())
}

