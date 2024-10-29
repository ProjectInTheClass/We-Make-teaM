//
//  AddEventView.swift
import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [Event]
    
    @State private var selectedColor: Color = .red
    @State private var title: String = ""
    @State private var endTime: Date = Date()
    @State private var participants: Int = 3
    @State private var location: String = ""
    @State private var reminder: String = "종료 1일 전"
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    let reminders = ["종료 1일 전", "종료 전", "후"]
    let participantsCount = Array(1...5)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("일정 추가하기")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 15) {
                    Text("*일정 제목:")
                    TextField("제목을 입력하세요", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack(spacing: 15) {
                    Text("*일정 마감:")
                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                HStack {
                    Text("*참여 인원:")
                    Picker("인원 선택", selection: $participants) {
                        ForEach(participantsCount, id: \.self) { count in
                            Text("\(count)명")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
                    let newEvent = Event(title: title, date: endTime, location: location)
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
            .navigationTitle("새 일정 추가")
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

#Preview {
    AddEventView(events: .constant([]))
}


