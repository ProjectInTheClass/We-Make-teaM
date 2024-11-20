//4.캘린더 화면
import SwiftUI

struct CalendarView: View{
    @State private var selectedDate: Date = Date()
    @State private var eventsForSelectedDate: [Event] = []
    @State private var isPresentingAddEventView = false
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var allEvents: [Event] = []
    
    var body: some View{
        VStack{
            CalendarHeader(selectedDate: $selectedDate)
            CalendarGrid(selectedDate: $selectedDate, events: allEvents) { date in
                loadEvents(for: date)
            }
            
            //해당 날짜의 추가된 일정들의 정보
            if !eventsForSelectedDate.isEmpty {
                Text("일정이 \(eventsForSelectedDate.count)개 있어요")
                    .font(.headline)
                    .padding(.top, 20)
                
                ForEach(eventsForSelectedDate) { event in
                    NavigationLink(destination: SubmitView(event: event)) { // 클릭 시 SubmitView로 이동
                        HStack {
                            Circle()
                                .fill(event.color)
                                .frame(width: 10, height: 10)
                            Text(event.title)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal, 10)
                    }
                }
            } else {
                Text("일정이 없습니다")
                    .padding(.top, 20)
            }
                
            // 일정 추가 버튼
            Button(action: {
                isPresentingAddEventView = true
            }) {
                Text("+ 일정 추가하기")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 20)
            .sheet(isPresented: $isPresentingAddEventView) {
                AddEventView(events: $allEvents, initialDate: selectedDate)
                    .onDisappear {
                        loadEvents(for: selectedDate)
                    }
            }
        }
        .onAppear {
            allEvents = loadDummyEvents()
            loadEvents(for: selectedDate) // 더미 데이터를 초기 로드
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                navigationManager.resetToRoot()
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
        
    }
    
    func loadEvents(for date: Date){
        eventsForSelectedDate = allEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
    }
    
    func loadDummyEvents() -> [Event] {
        var events: [Event] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let event1 = ("2024-11-05", "더미데이터 작성", "회의실 A", Color.blue, ["김현경", "신준용"])
        let event2 = ("2024-11-12", "Data schema 짜기", "온라인", Color.green, ["신준용", "정광석"])
        let event3 = ("2024-11-19", "git 올리기", "사무실 2층", Color.orange, ["김현경", "신준용","정광석"])
            
        let eventsData = [event1, event2, event3]
        
        for (dateString, title, location, color, participants) in eventsData {
            if let date = formatter.date(from: dateString) {
                events.append(Event(title: title, date: date, location: location, color: color, participants: participants))
            }
        }
        
        return events
    }
    
}

//캘린더 헤더
struct CalendarHeader: View{
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    
    var body: some View{
        HStack{
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
            }){
                Image(systemName: "chevron.left")
            }
            .padding(.leading, 100)
            
            Spacer()
            Text("\(calendar.component(.year, from: selectedDate))년 \(calendar.component(.month, from: selectedDate))월")
                .font(.headline)
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: +1, to: selectedDate)!
            }){
                Image(systemName: "chevron.right")
            }
            .padding(.trailing, 100)
        }
    }
}

//캘린더 그리드
struct CalendarGrid: View {
    @Binding var selectedDate: Date
    var events: [Event]
    var onDateSelected: (Date) -> Void
    
    var body: some View {
        let calendar = Calendar.current
        let days = generateDaysInMonth(for: selectedDate)
        
        VStack {
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
            }
            
            ForEach(0..<days.count / 7, id: \.self) { row in
                HStack {
                    ForEach(0..<7, id: \.self) { column in
                        let day = days[row * 7 + column]
                        Button(action: {
                            selectedDate = day
                            onDateSelected(day)
                        }) {
                            VStack {
                                Text("\(calendar.component(.day, from: day))")
                                    .font(.system(size: 12))
                                    .foregroundColor(calendar.isDate(selectedDate, inSameDayAs: day) ? .white : .primary)
                                    .padding(8)
                                    .background(calendar.isDate(selectedDate, inSameDayAs: day) ? Color.blue : Color.clear)
                                    .clipShape(Circle())
                                
                                // 일정 색상 표시
                                HStack(spacing: 2) {
                                    ForEach(eventsForDate(day).prefix(3), id: \.self) { eventColor in
                                        Circle()
                                            .fill(eventColor)
                                            .frame(width: 6, height: 6)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .padding()
    }
    
    //해당 날짜에 이벤트 색상 배열을 반환
    private func eventsForDate(_ date: Date) -> [Color]{
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.map { $0.color }
    }
    
    // 선택된 월의 날짜 배열을 생성하는 함수
    private func generateDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let startDay = calendar.component(.weekday, from: startOfMonth) - 1 // 0 기준으로 변경
        return Array(0..<(startDay + range.count)).map {
            calendar.date(byAdding: .day, value: $0 - startDay, to: startOfMonth) ?? Date()
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(NavigationManager())
}
