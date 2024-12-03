//팀프로젝트 방 생성
import SwiftUI

struct CreateProjectView: View{
    @Environment(\.dismiss) var dismiss
    @Binding var projects: [String]
    @State private var teamName: String = ""   //팀명
    @State private var selectedMemberCount: Int = 1  //팀 맴버수
    @State private var selectedYear: Int = 2024   //프로젝트 진행년도
    @State private var selectedSemester: Int = 1    //프로젝트 진행학기
    @State private var teamPWD: String = ""   //프로젝트방 비밀번호
    @State private var isPresentingCompletionView = false   //프로제트 생성완료
    @State private var teamID: String = "aHdldlxlIskd" //프로젝트 방검색 ID
    
    let memberCounts = Array(1...6) //팀 멤버수 1~5명까지로 제한
    let years = Array(2020...2025)
    let semesters = [1,2]
    
    var body: some View{
        NavigationView{
            VStack(alignment: .leading, spacing: 15){
                
                Text("팀프로젝트 생성")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("팀명: ", text: $teamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack(){
                    Text("참여 인원수:")
                    Picker("", selection: $selectedMemberCount){
                        ForEach(memberCounts, id: \.self){ count in
                            Text("\(count)").tag(count)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 60)
                }
                
                HStack(){
                    Text("진행 학기:")
                    Picker("년도", selection: $selectedYear){
                        ForEach(years, id: \.self){ year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100)
                    
                    Picker("학기", selection: $selectedSemester){
                        ForEach(semesters, id:\.self){ semester in
                            Text("\(semester)").tag(semester)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 60)
                    
                }
                
                HStack(){
                    Text("방 비밀번호:")
                    TextField("",text: $teamPWD)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                Button(action:{
                    isPresentingCompletionView=true
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
            .navigationTitle("")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $isPresentingCompletionView){
                CompletionView(teamName: teamName, teamPWD: teamPWD, teamID: teamID, projects: $projects){
                    dismiss()
                }
            }
        }
    }
}


#Preview {
    CreateProjectView(projects: .constant(["소프트웨어 스튜디오 2"]))
}


