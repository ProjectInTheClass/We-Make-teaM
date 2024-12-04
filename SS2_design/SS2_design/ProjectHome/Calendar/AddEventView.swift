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
                Text("일정 추가")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
    
                
                HStack(spacing: 15) {
                    Text("* 일정 제목:")
                        .fontWeight(.semibold)
                    TextField("제목을 입력하세요", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Spacer()
                }
                
                HStack {
                    Text("* 일정 마감:")
                        .fontWeight(.semibold)
                    ZStack {
                        // 배경색 추가
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white) // 배경색 설정
                            .frame(height: 40)

                        // DatePicker
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden() // Label 숨기기
                            .padding(.trailing, 150)
                    }
                    
                }

            
                
                // 참여 인원 선택
                VStack(alignment: .leading) {
                    Text("* 참여 인원:")
                        .fontWeight(.semibold)
                    ForEach(members, id: \.self) { member in
                        HStack {
                            Text(member)
                
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
                        .padding(.leading, 20)
                    }
                }
                
                HStack {
                    Text("*장소:")
                        .fontWeight(.semibold)
                    TextField("장소를 입력하세요", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("*알림:")
                        .fontWeight(.semibold)
                    Picker("알림 설정", selection: $reminder)
                    {
                        ForEach(reminders, id: \.self) { reminder in
                            Text(reminder)
                                .foregroundColor(Color.black)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.black)//default 색상
                    .foregroundColor(.black) // Picker 텍스트 색상
                    //.background(Color.yellow.opacity(0.2)) // Picker 배경색 설정
                    .border(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                }
                
                HStack {
                    Text("*중요도:")
                        .fontWeight(.semibold)
                    ForEach(1...3, id: \.self) { index in
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
                        .fontWeight(.semibold)
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
                Spacer()
                
                Button(action: {
                    let newEvent = Event(title: title, date: endTime, location: location, color: selectedColor, participants: selectedMembers)
                    events.append(newEvent)
                    dismiss()
                }) {
                    Text("만들기")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.6))
                        .border(Color.gray, width:1.3)
                        .cornerRadius(3)
                }
                .frame(width: 300)
                .frame(maxWidth: .infinity)
                Spacer()
                
            }
            
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.yellow)
                    }
                }
            }
            .padding(.horizontal, 10)
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
