import SwiftUI

struct CharacterAndPlaneSelectionView: View {
    @Binding var selectedCharacter: String
    @Binding var selectedPlane: String
    
    let characters = ["char1", "char2", "char3", "char4", "char5", "char6"]
    
    let planes: [(name: String, size: CGSize)] = [
        (name: "colored_plane", size: CGSize(width: 420, height: 270)),
        (name: "colored_plane2", size: CGSize(width: 450, height: 270)),
        (name: "colored_plane3", size: CGSize(width: 400, height: 250))
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                ZStack {
                    if let plane = planes.first(where: { $0.name == selectedPlane }) {
                        Image(plane.name)
                            .resizable()
                            .frame(width: plane.size.width, height: plane.size.height)
                    }
                    
                    Image(selectedCharacter)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                .padding()
            }
            
            TabView {
                VStack {
                    Text("캐릭터 선택")
                        .font(.headline)
                        .padding()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                            ForEach(characters, id: \.self) { character in
                                Button(action: {
                                    selectedCharacter = character
                                }) {
                                    Image(character)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(selectedCharacter == character ? Color.blue : Color.gray, lineWidth: 3))
                                }
                            }
                        }
                    }
                    .padding()
                }
                .tabItem {
                    Label("캐릭터", systemImage: "person.fill")
                }
                
                VStack {
                    Text("비행기 선택")
                        .font(.headline)
                        .padding()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                            ForEach(planes, id: \.name) { plane in
                                Button(action: {
                                    selectedPlane = plane.name
                                }) {
                                    Image(plane.name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedPlane == plane.name ? Color.blue : Color.gray, lineWidth: 3))
                                }
                            }
                        }
                    }
                    .padding()
                }
                .tabItem {
                    Label("비행기", systemImage: "airplane")
                }
            }
            .frame(height: 300)
            
            Button(action: {
                print("캐릭터와 비행기 선택 완료!")
            }) {
                Text("완료하기")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("캐릭터 & 비행기 선택")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CharacterAndPlaneSelectionView_Previews: PreviewProvider {
    @State static var selectedCharacter = "char3"
    @State static var selectedPlane = "colored_plane"
    
    static var previews: some View {
        NavigationView {
            CharacterAndPlaneSelectionView(selectedCharacter: $selectedCharacter, selectedPlane: $selectedPlane)
        }
    }
}

