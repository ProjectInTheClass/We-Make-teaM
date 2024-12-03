import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateProjectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var projects: [String]
    @State private var teamName: String = ""   // 팀명
    @State private var selectedMemberCount: Int = 1  // 팀 멤버 수
    @State private var selectedYear: Int = 2024   // 프로젝트 진행 연도
    @State private var selectedSemester: Int = 1    // 프로젝트 진행 학기
    @State private var isPresentingCompletionView = false   // 프로젝트 생성 완료
    @State private var errorMessage: String = "" // 오류 메시지

    let memberCounts = Array(1...6) // 팀 멤버 수 1~6명까지로 제한
    let years = Array(2020...2025)
    let semesters = [1, 2]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("팀프로젝트 생성")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("팀명: ", text: $teamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("참여 인원수:")
                    Picker("", selection: $selectedMemberCount) {
                        ForEach(memberCounts, id: \.self) { count in
                            Text("\(count)").tag(count)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 60)
                }
                
                HStack {
                    Text("진행 학기:")
                    Picker("년도", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100)
                    
                    Picker("학기", selection: $selectedSemester) {
                        ForEach(semesters, id: \.self) { semester in
                            Text("\(semester)").tag(semester)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 60)
                }
                
                Spacer()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                Button(action: createProject) {
                    Text("완료")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $isPresentingCompletionView) {
                CompletionView(teamName: teamName, projects: $projects) {
                    dismiss()
                }
            }
        }
    }
    
    /// Firestore에 프로젝트 저장
    func createProject() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "사용자가 인증되지 않았습니다."
            return
        }
        
        guard !teamName.isEmpty else {
            errorMessage = "팀명을 입력해주세요."
            return
        }
        
        let db = Firestore.firestore()
        let projectData: [String: Any] = [
            "teamName": teamName,
            "memberCount": selectedMemberCount,
            "year": selectedYear,
            "semester": selectedSemester,
            "memberIds": [userId], // 현재 사용자만 초기 멤버로 설정
            "createdAt": Timestamp()
        ]
        
        db.collection("Project").addDocument(data: projectData) { error in
            if let error = error {
                errorMessage = "프로젝트 생성 실패: \(error.localizedDescription)"
            } else {
                print("프로젝트 생성 성공!")
                projects.append(teamName) // 로컬 상태 업데이트
                isPresentingCompletionView = true // 완료 화면 표시
            }
        }
    }
}

#Preview {
    CreateProjectView(projects: .constant(["소프트웨어 스튜디오 2"]))
}
