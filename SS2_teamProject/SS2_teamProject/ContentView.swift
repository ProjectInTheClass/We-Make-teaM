//프로젝트들 목록 + 새 프로젝트 생성
import SwiftUI

struct ContentView: View {
    @State private var isPresentingCreateProject = false //새로운 프로젝트 생성
    @State private var projects: [String] = ["소프트웨어 스튜디오2"] //생성된 프로젝트들
    
    
    var body: some View {
        NavigationView{
            VStack(){
                Button(action:{
                    isPresentingCreateProject = true
                }){
                    Text("+ 팀프로젝트 생성하기 ")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isPresentingCreateProject){
                    CreateProjectView(projects: $projects)
                        
                }
                .padding(.bottom, 3)
                .padding(.top, 15)
               
                
                ScrollView{
                    ForEach(projects, id:\.self){project in
                        NavigationLink(destination: ProjectHomeView(projectName: project)){
                            Text(project)
                                .frame(maxWidth: .infinity) //이건 나중에 부모뷰의 비율로 바꿔서 사용ㄱㄱ
                                .frame(width:300,height:30)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("")
            .navigationBarItems(trailing: HStack {
                Button(action:{
                    //메인 페이지로 이동하는 동작
                }){
                    Text("WMM")
                        .font(.headline)
                        .foregroundColor(.blue)
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
}

#Preview {
    ContentView()
}
