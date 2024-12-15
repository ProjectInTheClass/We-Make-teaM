import SwiftUI

struct ChangeCharacterView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCharacter: String
    @Binding var selectedPlane: String

    let characters = ["char1", "char2", "char3", "char4", "char5", "char6"]
    let planes = ["p1", "p2", "p3", "pp1", "pp2", "pp3"]
    
    @State private var selectedTab = 0 // 0: 캐릭터, 1: 비행기

    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.2)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단의 뒤로가기 버튼
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("on")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    
                    Spacer()
                }
                .padding(.top)

                // 캐릭터와 비행기 이미지 선택 미리보기
                VStack {
                    ZStack {
                        Image(selectedPlane)
                            .resizable()
                            .scaledToFit()
                            .frame(width: sizeForPlane(selectedPlane).width, height: sizeForPlane(selectedPlane).height)
                        
                        Image(selectedCharacter)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280) // 선택된 캐릭터의 크기 고정
                    }
                    .padding(5)
                }

                // Picker (캐릭터와 비행기 탭)
                Picker("선택", selection: $selectedTab) {
                    Text("캐릭터").tag(0)
                    Text("비행기").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // 캐릭터 선택 섹션
                if selectedTab == 0 {
                    VStack {
                        Divider()
                            .padding(10)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 15)], spacing: 15) {
                                ForEach(characters, id: \.self) { character in
                                    Button(action: {
                                        selectedCharacter = character
                                    }) {
                                        Image(character)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100) // 고정된 크기
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedCharacter == character ? Color.blue : Color.gray, lineWidth: 3)
                                            )
                                    }
                                    .frame(width: 100, height: 100) // 각 셀의 고정된 크기
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // 비행기 선택 섹션
                if selectedTab == 1 {
                    VStack {
                        Divider()
                            .padding(10)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 15)], spacing: 15) {
                                ForEach(planes, id: \.self) { plane in
                                    Button(action: {
                                        selectedPlane = plane
                                    }) {
                                        Image(plane)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 60) // 선택 버튼의 크기 고정
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedPlane == plane ? Color.blue : Color.gray, lineWidth: 3)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // 완료 버튼
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.horizontal, 50)
            }
        }
        .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
        .navigationBarItems(trailing: HStack {
            Button(action: {
                debugPrint(navigationManager.path)
                navigationManager.resetToRoot()
            }) {
                Text("WMM")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            NavigationLink(destination: SettingView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        })
    }

    // 비행기의 크기를 정의하는 함수
    func sizeForPlane(_ plane: String) -> CGSize {
        switch plane {
        case "p1":
            return CGSize(width: 420, height: 270)
        case "p2":
            return CGSize(width: 420, height: 270)
        case "p3":
            return CGSize(width: 420, height: 270)
        case "pp1":
            return CGSize(width: 420, height: 270)
        case "pp2":
            return CGSize(width: 420, height: 270)
        case "pp3":
            return CGSize(width: 420, height: 270)
        default:
            return CGSize(width: 180, height: 90) // 기본 크기
        }
    }
}

#Preview {
    ChangeCharacterView(
        selectedCharacter: .constant("char3"),
        selectedPlane: .constant("p1")
    )
    .environmentObject(NavigationManager())
}
