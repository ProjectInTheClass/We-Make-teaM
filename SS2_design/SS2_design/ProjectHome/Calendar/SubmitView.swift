import SwiftUI
import FirebaseFirestore




struct SubmitView: View {
    var event: Event // Specific event details
    var selectedDate: Date
    @State private var members: [Member] = []
    @State public var eventid : String
    // Firebase에서 멤버를 가져오는 함수
    func fetchMembersForEvent() {
        let db = Firestore.firestore()
        
        // 특정 이벤트의 title로 참가자 목록을 가져오는 쿼리
        db.collection("events")
            .whereField("projectName", isEqualTo: event.projectName) // 프로젝트 이름으로 필터링
            .whereField("title", isEqualTo: event.title) // 특정 이벤트 title로 필터링
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching members: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No events found.")
                    return
                }
                
                // Firestore에서 데이터를 가져와 members 배열 업데이트
                var fetchedMembers: [Member] = []
                let dispatchGroup = DispatchGroup()  // 동기화를 위한 DispatchGroup 사용

                for document in documents {
                    let data = document.data()
                    let evendId = document.documentID
                    // 참가자 리스트를 가져와서 멤버를 처리
                    if let participants = data["participants"] as? [String] {
                        for memberId in participants {
                            dispatchGroup.enter()  // DispatchGroup에 엔트리 추가
                            
                            // users 컬렉션에서 memberId에 해당하는 닉네임을 가져옴
                            db.collection("users").document(memberId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("Error fetching user data: \(error.localizedDescription)")
                                } else if let userData = userSnapshot?.data() {
                                    // 닉네임을 가져와서 멤버 객체에 추가
                                    if let nickname = userData["nickname"] as? String {
                                        let member = Member(name: nickname, hasSubmitted: false)
                                        fetchedMembers.append(member)
                                    }
                                }
                                
                                dispatchGroup.leave()  // DispatchGroup에서 엔트리 제거
                            }
                        }
                    }
                }

                // 모든 비동기 요청이 완료된 후 멤버 데이터 업데이트
                dispatchGroup.notify(queue: .main) {
                    self.members = fetchedMembers
                }
            }
    }
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
                if let myIndex = members.firstIndex(where: { $0.name == "정광석" }) {
                    members[myIndex].hasSubmitted = true
                }
            }, event : eventid)) {
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
        .onAppear {
            fetchMembersForEvent() // View가 나타날 때 멤버 데이터를 불러옴
        }

    }

}

struct Member: Identifiable {
    let id = UUID()
    let name: String
    var hasSubmitted: Bool
}

#Preview {
    SubmitView(event: Event(projectName : "asdf",title: "디자인 중간 발표", date: Date(), location: "잇빗 507호", color: .red, participants: ["A", "B"]), selectedDate: Date(), eventid: "1CobECae5xKKErSf7HjX"
)
}

