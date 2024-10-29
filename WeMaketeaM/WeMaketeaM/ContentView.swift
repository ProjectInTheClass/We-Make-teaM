import SwiftUI

struct ContentView: View {
    @State private var isPresentingCreateProject = false
    @State private var projects: [String] = ["소프트웨어 스튜디오 2"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    isPresentingCreateProject = true
                }) {
                    Text("+ 프로젝트 생성하기")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isPresentingCreateProject) {
                    CreateProjectView(projects: $projects)
                }
                
                ScrollView {
                    ForEach(projects, id: \.self) { project in
                        NavigationLink(destination: ProjectHomeView(projectName: project)) {
                            Text(project)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.top, 10)
                
            }
            .navigationTitle("첫시작")
        }
    }
}

#Preview {
    ContentView()
}

