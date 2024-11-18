//1-1. 프로젝트 방 생성화면
import SwiftUI

struct CreateProjectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var projects: [String]
    @State private var teamName: String = ""
    @State private var selectedMemberCount: Int = 1
    @State private var selectedYear: Int = 2024
    @State private var selectedSemester: Int = 1
    @State private var isPresentingCompletionView = false

    let memberCounts = Array(1...10)
    let years = Array(2020...2025)
    let semesters = [1, 2]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("팀 생성")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("팀명:", text: $teamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("인원수:")
                    Picker("", selection: $selectedMemberCount) {
                        ForEach(memberCounts, id: \.self) { count in
                            Text("\(count)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100)
                }
                
                HStack {
                    Text("진행학기:")
                    Picker("년도", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(year)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100)
                    
                    Picker("학기", selection: $selectedSemester) {
                        ForEach(semesters, id: \.self) { semester in
                            Text("\(semester)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 50)
                }
                
                Spacer()
                
                Button(action: {
                    isPresentingCompletionView = true
                }) {
                    Text("완료")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("팀 생성")
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
                    dismiss()  // CreateProjectView를 닫고 첫 페이지로 이동
                }
            }
        }
    }
}

#Preview {
    CreateProjectView(projects: .constant(["소프트웨어 스튜디오 2"]))
}
