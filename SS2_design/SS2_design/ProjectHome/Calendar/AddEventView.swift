import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [Event]
    var initialDate: Date
    var projectName: String
    @State private var selectedColor: Color = .red
    @State private var title: String = ""
    @State private var endTime: Date = Date()
    @State private var location: String = ""
    @State private var reminder: String = "종료 1일 전"
    @State private var importance: Int = 0  // 중요도 (별점 수)
    
    // 프로젝트 방의 멤버 ID와 이름을 관리
    @State private var membersId: [String] = []  // ID 목록
    @State private var members: [String: String] = [:]  // ID와 이름을 매핑하는 딕셔너리
    @State private var selectedMembers: [String] = [] // 선택된 멤버의 ID 목록
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    let reminders = ["종료 1일 전", "종료 12시간 전", "종료 6시간 전", "종료 2시간 전", "종료 1시간 전", "종료 30분 전"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("일정 추가")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                
                HStack(spacing: 15) {
                    Text("* 일정 제목:")
                        .fontWeight(.semibold)
                    TextField("제목을 입력하세요", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Spacer()
                }
                
                HStack {
                    Text("* 일정 마감:")
                        .fontWeight(.semibold)
                    ZStack {
                        // 배경색 추가
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white) // 배경색 설정
                            .frame(height: 40)

                        // DatePicker
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden() // Label 숨기기
                            .padding(.trailing, 150)
                    }
                }
                
                // 참여 인원 선택
                VStack(alignment: .leading) {
                    Text("* 참여 인원:")
                        .fontWeight(.semibold)
                    ForEach(membersId, id: \.self) { memberId in
                        HStack {
                            Text(members[memberId] ?? "Unknown")  // ID에 해당하는 이름 표시
                            
                            Image(systemName: selectedMembers.contains(memberId) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedMembers.contains(memberId) ? .blue : .gray)
                                .onTapGesture {
                                    if let index = selectedMembers.firstIndex(of: memberId) {
                                        selectedMembers.remove(at: index)
                                    } else {
                                        selectedMembers.append(memberId)
                                    }
                                }
                        }
                        .padding(.vertical, 5)
                        .padding(.leading, 20)
                    }
                }
                
                HStack {
                    Text("*장소:")
                        .fontWeight(.semibold)
                    TextField("장소를 입력하세요", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("*알림:")
                        .fontWeight(.semibold)
                    Picker("알림 설정", selection: $reminder)
                    {
                        ForEach(reminders, id: \.self) { reminder in
                            Text(reminder)
                                .foregroundColor(Color.black)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.black) //default 색상
                    .foregroundColor(.black) // Picker 텍스트 색상
                    .border(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                }
                
                HStack {
                    Text("*중요도:")
                        .fontWeight(.semibold)
                    ForEach(1...3, id: \.self) { index in
                        Image(systemName: index <= importance ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(index <= importance ? .yellow : .gray)
                            .onTapGesture {
                                importance = index
                            }
                    }
                }

                HStack(spacing: 15) {
                    Text("*색상 선택:")
                        .fontWeight(.semibold)
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                selectedColor = color
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                            )
                    }
                }
                
                Spacer()
                Spacer()
                
                Button(action: {
                    saveEventToFirestore()
                    dismiss()
                }) {
                    Text("만들기")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.6))
                        .border(Color.gray, width:1.3)
                        .cornerRadius(3)
                }
                .frame(width: 300)
                .frame(maxWidth: .infinity)
                Spacer()
            }
            
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.yellow)
                    }
                }
            }
            .padding(.horizontal, 10)
            .onAppear {
                fetchMembersFromFirestore()  // Firestore에서 멤버 정보 가져오기
            }
        }
    }

    // Firestore에서 멤버 정보 가져오는 메서드
    // Firestore에서 멤버 정보 가져오는 메서드
    func fetchMembersFromFirestore() {
        let db = Firestore.firestore()
        
        // 프로젝트 이름으로 프로젝트 문서를 찾기
        db.collection("Project")
            .whereField("teamName", isEqualTo: projectName)  // 'name' 필드가 프로젝트 이름인 경우
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("프로젝트 멤버 불러오기 실패: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = querySnapshot, !snapshot.isEmpty {
                    let document = snapshot.documents.first
                    if let membersList = document?.data()["memberIds"] as? [String] {
                        self.membersId = membersList
                        print("hello1")
                        
                        // 각 멤버의 ID에 대해 이름을 가져와서 members 딕셔너리에 저장
                        for memberId in membersList {
                            db.collection("users").document(memberId)
                                .getDocument { userDocument, error in
                                    if let userDocument = userDocument, userDocument.exists {
                                        if let name = userDocument.data()?["nickname"] as? String {
                                            self.members[memberId] = name
                                        }
                                    }
                                }
                        }
                    }
                } else {
                    print("프로젝트 이름에 해당하는 문서를 찾을 수 없습니다.")
                }
            }
    }


    // Firestore에 이벤트 저장 메서드
    func saveEventToFirestore() {
        let newEvent = Event(
            projectName: projectName,
            title: title,
            date: initialDate,
            location: location,
            color: selectedColor,
            participants: selectedMembers  // ID로 저장
        )
        
        let db = Firestore.firestore()
        let eventData: [String: Any] = [
            "projectName": projectName,
            "title": title,
            "date": initialDate,
            "color": selectedColor.description,
            "location": location,
            "participants": selectedMembers,
            "importance": importance,
            "createdAt": FieldValue.serverTimestamp() // 서버 시간 추가
        ]
        var ref: DocumentReference? = nil
        ref = db.collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Firestore 저장 실패: \(error.localizedDescription)")
            } else {
                print("Firestore 저장 성공!")
                events.append(newEvent)  // 로컬 데이터 업데이트
                
                
               
               // 참여한 멤버에 대해 submission 문서 추가
                addSubmissionDocuments(eventId: ref?.documentID ?? "")
                dismiss()  // 화면 닫기
            }
        }
    }
    
    // 각 멤버에 대해 submission 문서를 추가하는 메서드
    func addSubmissionDocuments(eventId: String) {
        let db = Firestore.firestore()

        // 선택된 멤버들에 대해 submission 문서를 생성
        for memberId in selectedMembers {
            let submissionData: [String: Any] = [
                "eventId": eventId,
                "memberId": memberId,
                "deadline": Timestamp(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!), // 예시: 마감 시간을 하루 전으로 설정
                "fileName": "",
                "isSubmitted": false,
                "priority": importance, // 중요도 값 추가
                "URL" : ""
            ]
            
            db.collection("Submissions").addDocument(data: submissionData) { error in
                if let error = error {
                    print("Submission 문서 저장 실패: \(error.localizedDescription)")
                } else {
                    print("Submission 문서 저장 성공!")
                }
            }
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let projectName: String
    let title: String
    let date: Date
    let location: String
    let color: Color
    let participants: [String]  // 참여 인원 ID 목록
}

#Preview {
    AddEventView(events: .constant([]), initialDate: Date(), projectName: "asdf")
}
