//팀프로젝트 방 생성
import SwiftUI

struct CreateProjectView: View{
    @Environment(\.dismiss) var dismiss
    @Binding var projects: [Project]
    @State private var teamID: String = UUID().uuidString //프로젝트 방검색 ID
    @State private var teamName: String = ""   //팀명
    @State private var teamPWD: String = ""   //프로젝트방 비밀번호
    @State private var selectedMemberCount: Int = 1  //팀 맴버수
    @State private var selectedYear: Int = 2024   //프로젝트 진행년도
    @State private var selectedSemester: Int = 1    //프로젝트 진행학기
    @State private var isPresentingCompletionView = false   //프로제트 생성완료
  
    
    let memberCounts = Array(1...6) //팀 멤버수 1~5명까지로 제한
    let years = Array(2020...2025)
    let semesters = [1,2]
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none // 콤마 제거
        return formatter
    }()
    
    var body: some View{
        NavigationView{
            ZStack {
                Color.yellow
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack {
                    Text("팀프로젝트 생성")
                        .font(.system(size: 30, weight: .regular, design: .rounded))
                        .bold()
                        .offset(y: 0)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    Spacer()

                    VStack(alignment: .leading, spacing: 40) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("팀명")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                            
                            TextField("", text: $teamName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(15)
                                .frame(height: 45)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 3)
                                )
                                .frame(height: 40)
                        }
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 5){
                            Text("비밀번호")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .fontWeight(.black)
                            TextField("",text: $teamPWD)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(15)
                                .frame(height: 45)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 3)
                                )
                                .frame(height: 50)
                        }
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 5){
                            Text("참여 인원수")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                
                            Picker("", selection: $selectedMemberCount){
                                ForEach(memberCounts, id: \.self){ count in
                                    Text("\(count)").tag(count)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(.black)
                            .frame(maxWidth: 50)
                            .background(Color.white)
                            .border(Color.black, width: 2)
                            .cornerRadius(3)
                        }
                        .padding(.horizontal, 20)
                                           
                        VStack(alignment: .leading, spacing: 5){
                            Text("진행 학기")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
        
                            HStack{
                                Picker("년도", selection: $selectedYear){
                                    ForEach(years, id: \.self){ year in
                                        Text(numberFormatter.string(from: NSNumber(value: year)) ?? "\(year)")
                                                    .tag(year)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.black)
                                .frame(maxWidth: 95)
                                .background(Color.white)
                                .border(Color.black, width: 2)
                                .cornerRadius(3)
                    
                                Picker("학기", selection: $selectedSemester){
                                    ForEach(semesters, id:\.self){ semester in
                                        Text("\(semester)").tag(semester)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.black)
                                .frame(maxWidth: 50)
                                .background(Color.white)
                                .border(Color.black, width: 2)
                                .cornerRadius(3)
                            }
                        }
                        .padding(.horizontal, 20)
        
                        Spacer()
                        
                        Button(action:{
                            let newProject = Project(teamName: teamName, teamPWD: teamPWD, year: selectedYear, semester: selectedSemester)
                            projects.append(newProject)
                            isPresentingCompletionView=true
                        }) {
                            Text("완료")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .fontDesign(.monospaced)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 60)
                                .background(Color.black)
                                .cornerRadius(30)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 0)
                        
                        Spacer()
                    }
                }
                .padding()
            }

            .navigationTitle("")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .fontWeight(.black)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $isPresentingCompletionView){
                let newProject = Project(teamName: teamName, teamPWD: teamPWD, year: selectedYear, semester: selectedSemester)
                    CompletionView(project: newProject) {
                        dismiss()
                    }
            }
            Spacer()
        }
    }
}

#Preview {
    CreateProjectView(projects: .constant([
        Project(teamName: "소프트웨어 스튜디오 2", teamPWD: "1234", year: 2024, semester: 1)
    ]))
}

