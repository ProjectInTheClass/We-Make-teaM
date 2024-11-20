//4-1캘린더에 이벤트 추가하는 페이지
//캘린더에 이벤트 추가하는 페이지
import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [Event]
    var initialDate: Date
    
    @State private var selectedColor: Color = .red
    @State private var title: String = ""
    @State private var endTime: Date = Date()
    @State private var location: String = ""
    @State private var reminder: String = "종료 1일 전"
    @State private var importance: Int = 0  // 중요도 (별점 수)
    
    // 프로젝트 방의 멤버 더미 데이터
    @State private var members: [String] = ["김현경", "신준용", "정광석"]
    @State private var selectedMembers: [String] = [] // 선택된 멤버를 저장
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    let reminders = ["종료 1일 전", "종료 12시간 전", "종료 6시간 전", "종료 2시간 전", "종료 1시간 전" , "종료 30분 전"]
    
    init(events: Binding<[Event]>, initialDate: Date) {
            self._events = events
            self.initialDate = initialDate
            self._endTime = State(initialValue: initialDate) // 선택한 날짜로 초기화
        }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("일정 추가하기")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Spacer()
                
                HStack(spacing: 15) {
                    Text("*일정 제목:")
                    TextField("제목을 입력하세요", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack(spacing: 15) {
                    Text("*일정 마감:")
                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                    Spacer()
                }
                
                // 참여 인원 선택
                VStack(alignment: .leading) {
                    Text("*참여 인원:")
                    ForEach(members, id: \.self) { member in
                        HStack {
                            Text(member)
                            Spacer()
                            Image(systemName: selectedMembers.contains(member) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedMembers.contains(member) ? .blue : .gray)
                                .onTapGesture {
                                    if let index = selectedMembers.firstIndex(of: member) {
                                        selectedMembers.remove(at: index)
                                    } else {
                                        selectedMembers.append(member)
                                    }
                                }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                HStack {
                    Text("*장소:")
                    TextField("장소를 입력하세요", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("*알림:")
                    Picker("알림 설정", selection: $reminder) {
                        ForEach(reminders, id: \.self) { reminder in
                            Text(reminder)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                HStack {
                    Text("*중요도:")
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= importance ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(index <= importance ? .yellow : .gray)
                            .onTapGesture {
                                importance = index
                            }
                    }
                }

                HStack(spacing: 15) {
                    Text("*색상 선택:")
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                selectedColor = color
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                            )
                    }
                }
                
                Spacer()
                
                Button(action: {
                    let newEvent = Event(title: title, date: endTime, location: location, color: selectedColor, participants: selectedMembers)
                    events.append(newEvent)
                    dismiss()
                }) {
                    Text("만들기")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let location: String
    let color: Color
    let participants: [String] // 참여 인원 정보 추가
}

#Preview {
    CalendarView()
}
