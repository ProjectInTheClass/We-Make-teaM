//캘린더 기능
import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date? = nil
    @State private var eventsForSelectedDate: [Event] = []
    @State private var isPresentingAddEventView = false

    var body: some View {
        VStack {
            DatePicker(
                "전체 일정",
                selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0; loadEvents(for: $0) }
                ),
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            if let date = selectedDate, !eventsForSelectedDate.isEmpty {
                Text("일정이 \(eventsForSelectedDate.count)개 있어요")
                    .font(.headline)
                    .padding(.top, 20)
                
                ForEach(eventsForSelectedDate) { event in
                    Text(event.title)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                }
                
                Button(action: {
                    print("일정 자세히 보기")
                }) {
                    Text("일정 자세히 보기")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                        .padding(.horizontal, 10)
                }
                
            } else {
                Text("일정이 없습니다")
                    .padding(.top, 20)
            }

            Button(action: {
                isPresentingAddEventView = true
            }) {
                Text("+ 일정 추가하기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $isPresentingAddEventView) {
            AddEventView(events: $eventsForSelectedDate)
        }
        .navigationTitle("전체 일정")
    }
    
    func loadEvents(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // 예시 이벤트를 특정 날짜에 추가
        if formatter.string(from: date) == "2024-06-26" {
            eventsForSelectedDate = [
                Event(title: "디자인 중간 발표", date: date, location: "잇힛 507호")
            ]
        } else {
            eventsForSelectedDate = []
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date 
    let location: String
}

#Preview {
    CalendarView()
}
