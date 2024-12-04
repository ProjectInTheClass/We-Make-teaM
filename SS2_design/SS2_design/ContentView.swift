
import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    @State private var isPresentingCreateProject = false //새로운 프로젝트 생성
    @State private var projects: [String] = ["소프트웨어 스튜디오2"] //생성된 프로젝트들
    //프로젝트 아이디와 비밀번호로 추가
    @State private var enteredProjectID = "" //추가할 프로젝트아이디
    @State private var enteredPassword = ""//추가할 비밀번호
    @State private var showAddProjectModal  = false //모달창
    @State private var isLoading = true // 로딩 상태

    
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
                    
                    ScrollView{
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
                .onAppear(perform: fetchProjects) // 화면 로드 시 프로젝트 데이터 불러오기
            }
        }
        .environmentObject(navigationManager)
    }
    
    func fetchProjects() {
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }

        let db = Firestore.firestore()
        db.collection("Project")
            .whereField("memberIds", arrayContains: userId) // 현재 사용자가 속한 프로젝트만 필터링
            .getDocuments { snapshot, error in
                if let error = error {
                    
                    return
                }

                if let snapshot = snapshot {
                    // 프로젝트 이름 배열 업데이트
                    self.projects = snapshot.documents.compactMap { document in
                        document.data()["teamName"] as? String
                    }
                }
                
            }
    }
}

struct AddProjectModalView: View {
    @Binding var enteredProjectID: String
    @Binding var enteredPassword: String
    @Binding var projects: [String]
    @Binding var showModal: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("프로젝트 추가")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            HStack(){
                Text("프로젝트 ID")
                    .padding(.leading,10)
                TextField("프로젝트 ID 입력", text: $enteredProjectID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            HStack(){

                Text("비밀번호")
                    .padding(.leading,10)
                SecureField("비밀번호 입력", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            
            
            Button(action: {
                // 입력된 ID와 비밀번호가 조건을 만족하면 프로젝트 추가
                if validateProject(id: enteredProjectID, password: enteredPassword) {
                    projects.append(enteredProjectID) // 프로젝트 추가
                    showModal = false // 모달 창 닫기
                } else {
                    // 입력값이 유효하지 않을 경우 처리
                    print("Invalid project ID or password")
                }
            }) {
                Text("추가")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Button(action: {
                showModal = false // 모달 창 닫기
            }) {
                Text("취소")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
    
    // 프로젝트 ID와 비밀번호 유효성 검사
    func validateProject(id: String, password: String) -> Bool {
        // 유효성 검사 로직 추가
        return id == "abcdefg" && password == "0000" // 예제 로직
    }
    /// Firestore에서 현재 사용자의 프로젝트 목록 불러오기
    
    
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
