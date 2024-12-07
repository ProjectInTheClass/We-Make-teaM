//
//팀프로젝트 방 생성
import SwiftUI

import FirebaseAuth
import FirebaseFirestore


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
    @State private var errorMessage: String = "" // 오류 메시지
    @State private var events : [String] = []
    let memberCounts = Array(1...6) //팀 멤버수 1~5명까지로 제한
    let years = Array(2020...2025)
    let semesters = [1,2]
    
    var body: some View{
        NavigationView{
            ZStack(){
                VStack(spacing: 0) {
                    Color.yellow
                        .opacity(0.3)
                        .frame(height: 180) // 상단 배경 크기 조정
                        .ignoresSafeArea(edges: .top)
                        //.overlay(
                        //    Rectangle()
                        //        .frame(height: 2)
                        //        .foregroundColor(Color.brown.opacity(0.5)) // 선 색상
                        //                .padding(.top, 0), // 하단 선 위치 조정
                        //            alignment: .bottom
                        //        )
                        //.offset(y: -6)
    
                    Spacer() // 나머지는 흰색으로 덮음
                }
                
                VStack(alignment: .leading, spacing: 20){
                    
            
                    ZStack {
                    
                        Text("팀프로젝트 생성")
                            .font(.system(size: 40, weight: .regular, design: .rounded))
                            //.foregroundColor(.white)
                            .bold()
                            .offset(y:-10)

        
    
                        Image("plane3")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .offset(x: 100, y: 60)
    
            
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 0)
                    .frame(maxWidth: .infinity) // 가로로 꽉 차게 설정
            

                    
                    VStack(alignment: .leading, spacing: 20){
                        VStack(alignment: .leading){
                            Text("팀명")
                                .font(.title3)
                                .fontWeight(.black)
                                //.foregroundColor(.yellow)
                            TextField("",text: $teamName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.bottom, 5)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2) // 하단 선의 높이
                                        .foregroundColor(Color.black.opacity(0.6)) // 선 색상
                                                .padding(.top, 20), // 하단 선 위치 조정
                                            alignment: .bottom // 하단에만 선 배치
                                        )
                                        .frame(width: 250)
                        }
                        
                        VStack(alignment: .leading){
                            Text("비밀번호")
                                .font(.title3)
                                .fontWeight(.black)
                                //.foregroundColor(.yellow)
                            
                            TextField("",text: $teamPWD)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.bottom, 5)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2) // 하단 선의 높이
                                        .foregroundColor(Color.black.opacity(0.6)) // 선 색상
                                                .padding(.top, 20), // 하단 선 위치 조정
                                            alignment: .bottom // 하단에만 선 배치
                                        )
                                        .frame(width: 250)
                        }
                        
                        VStack(alignment: .leading){
                            Text("참여 인원수")
                                .font(.title3)
                                .fontWeight(.semibold)
                                //.foregroundColor(.yellow)
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
                        
                        VStack(alignment: .leading){
                            Text("진행 학기")
                                .font(.title3)
                                .fontWeight(.semibold)
                                //.foregroundColor(.yellow)
                            HStack{
                                Picker("년도", selection: $selectedYear){
                                    ForEach(years, id: \.self){ year in
                                        Text("\(year)").tag(year)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.black)
                                .frame(maxWidth: 90)
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
                        
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(alignment:.center){
        
                        Button(action:{
                            isPresentingCompletionView=true
                            createProject()
                        }) {
                            Text("완료")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .fontDesign(.monospaced)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width:250, height:50)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        .padding(.top,0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                .padding()
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
                    CompletionView(teamName: teamName, teamPWD: teamPWD, teamID: teamID, projects: $projects){
                        dismiss()
                    }
                }
                Spacer()
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
            "teamPWD": teamPWD,
            "memberCount": selectedMemberCount,
            "year": selectedYear,
            "semester": selectedSemester,
            "memberIds": [userId], // 현재 사용자만 초기 멤버로 설정
            "createdAt": Timestamp()
        ]
        
        // Firestore에 문서 추가
        var ref: DocumentReference? = nil
        ref = db.collection("Project").addDocument(data: projectData) { error in
            if let error = error {
                self.errorMessage = "프로젝트 생성 실패: \(error.localizedDescription)"
            } else {
                // 문서가 성공적으로 저장되면 documentID를 가져와서 teamID에 업데이트
                if let ref = ref {
                    self.teamID = ref.documentID
                    print("생성된 문서 ID: \(self.teamID)")
                }
                self.isPresentingCompletionView = true // 완료 화면 표시
            }
        }
    }



   
    
}


#Preview {
    CreateProjectView(projects: .constant(["소프트웨어 스튜디오 2"]))
}
