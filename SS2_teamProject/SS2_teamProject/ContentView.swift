import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var isPresentingCreateProject = false // 새로운 프로젝트 생성
    @State private var projects: [String] = [] // 생성된 프로젝트들
    @State private var errorMessage: String = "" // 오류 메시지
    @State private var isLoading = true // 로딩 상태

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("로딩 중...")
                        .padding()
                } else {
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Button(action: {
                            isPresentingCreateProject = true
                        }) {
                            Text("+ 팀프로젝트 생성하기")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.blue.opacity(0.8))
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
                                        .frame(width: 300, height: 30)
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
                }
            }
            .navigationTitle("프로젝트 목록")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    // 메인 페이지로 이동하는 동작
                }) {
                    Text("WMM")
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            })
            .onAppear(perform: fetchProjects) // 화면 로드 시 프로젝트 데이터 불러오기
        }
    }

    /// Firestore에서 현재 사용자의 프로젝트 목록 불러오기
    func fetchProjects() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "사용자가 인증되지 않았습니다."
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        db.collection("Project")
            .whereField("memberIds", arrayContains: userId) // 현재 사용자가 속한 프로젝트만 필터링
            .getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "데이터 불러오기 실패: \(error.localizedDescription)"
                    isLoading = false
                    return
                }

                if let snapshot = snapshot {
                    // 프로젝트 이름 배열 업데이트
                    self.projects = snapshot.documents.compactMap { document in
                        document.data()["teamName"] as? String
                    }
                }
                isLoading = false
            }
    }
}

#Preview {
    ContentView()
}
