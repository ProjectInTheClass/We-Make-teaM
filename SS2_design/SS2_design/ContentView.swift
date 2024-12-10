//프로젝트들 목록 + 새 프로젝트 생성
import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    @State private var isPresentingCreateProject = false //새로운 프로젝트 생성
    @State private var projects: [String] = ["소프트웨어 스튜디오2"] //생성된 프로젝트들
    //프로젝트 아이디와 비밀번호로 추가
    @State private var enteredProjectID = "" //추가할 프로젝트아이디
    @State private var enteredPassword = ""//추가할 비밀번호
    @State private var showAddProjectModal  = false //모달창
    
    
    var body: some View {
        NavigationStack(path: $navigationManager.path){
            ZStack(){
                //Color.yellow
                  //  .opacity(0.3)
                    //.ignoresSafeArea()
                
                VStack(spacing: 0){
                    ArcShape()
                        .fill(Color.yellow.opacity(0.3)) // 색상 설정
                        .frame(width: UIScreen.main.bounds.width*1.3, height: 200)
                        .offset(y: -300)
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
    
                }
                
                VStack(){
                   
                    
                    ZStack {
                        Text("WMM")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .offset(x: 4, y: 4)

                        Text("WMM")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .offset(x: -4, y: -4)
                        
                        Text("WMM")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .offset(x: 4, y: -4)
                        
                        Text("WMM")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .offset(x: -4, y: 4)
 
                        Text("WMM")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                    }

                    
                    
                    Button(action:{
                        isPresentingCreateProject = true
                    }){
                        ZStack{
                            Text("+ 팀프로젝트 생성하기 ")
                                .foregroundColor(.yellow)
                                .fontWeight(.semibold)
                                .padding(.all, 7)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yellow, lineWidth: 2)
                                )
                            Text("+ 팀프로젝트 생성하기 ")
                                .foregroundColor(.black.opacity(0.5))
                                .fontWeight(.ultraLight)

                        }
                        
                    }
                    .sheet(isPresented: $isPresentingCreateProject){
                        CreateProjectView(projects: $projects)
                    }
                    .padding(.bottom, 3)
                    .offset(y: -30)
                   
        
                    Button(action:{
                        showAddProjectModal = true // 모달창 표시
                    }){
                        Text("+")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width:40, height:40)
                            .background(Color.yellow)
                            .cornerRadius(85)
                            .offset(y:-5)
                    }
                    .padding(.leading, 280)
                    .sheet(isPresented: $showAddProjectModal) {
                        AddProjectModalView(
                            enteredProjectID: $enteredProjectID,
                            enteredPassword: $enteredPassword,
                            projects: $projects,
                            showModal: $showAddProjectModal
                        )
                        .frame(height: 100)
                    }
                    
                    ScrollView {
                        ForEach(projects, id:\.self){project in
                            NavigationLink(destination: ProjectHomeView(projectName: project)){
                                VStack(alignment: .center ){
                                    Text(project)
                                        .foregroundColor(.black)
                                        .fontDesign(.rounded)
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .offset(y:5)
                                    HStack(){
                                        Spacer()
                                        Spacer()
                                        Image(systemName: "minus")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 3) // 선 두께 조정
                                                    .foregroundColor(.black) // 색상
                                                    .offset(x: -10)
                                        Image("plane2")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:80, height:80)
                                            //.background(Color.red)
                                            //.offset(y: -10)
                                        Image(systemName: "minus")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 3) // 선 두께 조정
                                                    .foregroundColor(.black) // 색상
                                                    .offset(x:1)
                                        Spacer()
                                        Spacer()
                                    }
                                    .offset(y:-5)

                                }
                                .frame(width:330,height:100)
                                //.frame(maxWidth: .infinity)
                                .background(Color.yellow.opacity(0.3))
                                .foregroundColor(.black)
                                .cornerRadius(9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9)
                                        .stroke(Color.yellow, lineWidth: 3)
                                )
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    .padding(.top, 10)
    
                }
                .navigationTitle("")
                .navigationBarItems(trailing: HStack {
                    Button(action:{
                        navigationManager.resetToRoot()
                        //메인 페이지로 이동하는 동작
                    }){
                        Text("WMM")
                            .font(.headline)
                            .foregroundColor(.black)

                        
                    }
                    
                    NavigationLink(destination: SettingView()){
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(.black)
                    }
                })
            }
        }
        .environmentObject(navigationManager)
    }
}

struct AddProjectModalView: View {
    @Binding var enteredProjectID: String
    @Binding var enteredPassword: String
    @Binding var projects: [String]
    @Binding var showModal: Bool
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("프로젝트 추가")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth:.infinity)
            Spacer()
            
            VStack(alignment: .leading, spacing: 30){
                VStack{
                    Text("프로젝트 ID")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //.padding(.leading,10)
                    TextField("프로젝트 ID 입력", text: $enteredProjectID)
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
                VStack{
                    Text("비밀번호")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //.padding(.leading,10)
                    SecureField("비밀번호 입력", text: $enteredPassword)
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
            }
            .padding(.horizontal,20)
        
            Spacer()
            
            VStack(spacing: 10){
                Button(action: {
                    // 입력된 ID와 비밀번호가 조건을 만족하면 프로젝트 추가
                    if validateProject(id: enteredProjectID, password: enteredPassword) {
                        projects.append(enteredProjectID) // 프로젝트 추가
                        showModal = false // 모달 창 닫기
                    } else {
                        // 입력값이 유효하지 않을 경우 처리
                        showAlert = true
                        print("Invalid project ID or password")
                    }
                }) {
                    Text("추가")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    showModal = false // 모달 창 닫기
                }) {
                    Text("취소")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
            }
            
            
            Spacer()
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("오류"),
                message: Text("프로젝트 ID 또는 비밀번호가 일치하지 않습니다."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    // 프로젝트 ID와 비밀번호 유효성 검사
    func validateProject(id: String, password: String) -> Bool {
        // 유효성 검사 로직 추가
        return id == "abcdefg" && password == "0000" // 예제 로직
    }
}

struct ArcShape: Shape{
    func path(in rect: CGRect) -> Path{
        var path = Path()
        path.addArc(
                    center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width/1.2,
                    startAngle: .degrees(360), // 시작 각도
                    endAngle: .degrees(180),  // 끝 각도
                    clockwise: false
                )
                return path
    }
}

#Preview {
    ContentView()
}
