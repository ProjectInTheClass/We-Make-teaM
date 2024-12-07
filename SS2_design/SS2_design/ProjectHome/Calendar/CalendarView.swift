//캘린더 화면
import SwiftUI
import FirebaseFirestore
import UIKit


struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var eventsForSelectedDate: [Event] = []
    @State private var isPresentingAddEventView = false
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var allEvents: [Event] = []
    var projectName : String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }
    
    var body: some View {
        VStack {
            CalendarHeader(selectedDate: $selectedDate)
            //Divider()
            CalendarGrid(selectedDate: $selectedDate, events: allEvents) { date in
                loadEvents(for: date)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            
            
            // 일정 리스트
            ScrollView {
                if !eventsForSelectedDate.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(selectedDate, formatter: dateFormatter) - \(eventsForSelectedDate.count)개 일정")
                            .font(.headline)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity)
                  
                        
                        ForEach(eventsForSelectedDate) { event in
                            NavigationLink(destination: SubmitView(event: event, selectedDate: selectedDate)) {
                                HStack {
                                    Circle()
                                        .fill(event.color)
                                        .frame(width: 10, height: 10)
                                    Text(event.title)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                } else {
                    Text("일정이 없습니다")
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            // 일정 추가 버튼
            Button(action: {
                isPresentingAddEventView = true
            }) {
                Text("+ 일정 추가하기")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(width:300)
                    .background(Color.yellow.opacity(0.6))
                    .border(Color.gray, width: 1.3)
                    .cornerRadius(3)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 20)
            .sheet(isPresented: $isPresentingAddEventView) {
                AddEventView(events: $allEvents, initialDate: selectedDate, projectName:projectName)
                    .onDisappear {
                        loadEvents(for: selectedDate)
                    }
            }
        }
        .onAppear {
           // Firestore에서 이벤트 가져오기
           fetchEventsFromFirestore(for: projectName) { events in
               allEvents = events
               loadEvents(for: selectedDate)
           }
       }
        .navigationTitle("캘린더")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
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
    
    func loadDummyEvents() -> [Event] {
        var events: [Event] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let event1 = ("asdf","2024-11-05", "더미데이터 작성", "회의실 A", Color.blue, ["김현경", "신준용"])
        let event2 = ("asdf","2024-11-12", "Data schema 짜기", "온라인", Color.green, ["신준용", "정광석"])
        let event3 = ("asdf","2024-11-19", "git 올리기", "사무실 2층", Color.orange, ["김현경", "신준용","정광석"])
            
        let eventsData = [event1, event2, event3]
        
        for (projectName, dateString, title, location, color, participants) in eventsData {
            if let date = formatter.date(from: dateString) {
                events.append(Event(projectName : projectName, title: title, date: date, location: location, color: color, participants: participants))
            }
        }
        
        return events
    }
    
    func loadEvents(for date: Date) {
        eventsForSelectedDate = allEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: date) && $0.projectName == projectName }
    }
    
}

// 캘린더 헤더
struct CalendarHeader: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
            }) {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            Spacer()
            Text(formattedYearMonth)
                .font(.title2)
                .padding(5)
                //.border(Color.yellow.opacity(0.5), width: 2)
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: +1, to: selectedDate)!
            }) {
                Image(systemName: "chevron.right")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
            Spacer()
        }
        .padding(.horizontal)
    }

    // 날짜를 "2024년 12월" 형식으로 변환
    private var formattedYearMonth: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: selectedDate)
    }
}



// 캘린더 그리드
struct CalendarGrid: View {
    @Binding var selectedDate: Date
    var events: [Event]
    var onDateSelected: (Date) -> Void

    var body: some View {
        GeometryReader { geometry in
            let gridWidth = geometry.size.width // 전체 너비 계산
            VStack(spacing: 0) {
                // 요일 헤더
                HStack(spacing: 0) {
                    ZStack {
                        // 배경색 추가
                        Color.yellow.opacity(0.6) // 원하는 배경색
                            .edgesIgnoringSafeArea(.horizontal) // 양쪽 끝까지 확장

                        VStack(spacing: 10) {
                            Divider()
                                .frame(height: 1)
                                .background(Color.gray)

                            HStack(spacing: 0) {
                                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                                    Text(day)
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                        .overlay(
                                            Divider()
                                                .background(Color.gray)
                                                .offset(x: gridWidth / 14), // 위치 조정
                                            alignment: .center
                                        )
                                }
                            }

                            Divider()
                                .frame(height: 1)
                                .background(Color.gray)
                        }
                    }
                }
                .padding(.vertical, 15)
                .offset(y: 10)

                // 날짜 그리드
                ForEach(0..<generateDaysInMonth(for: selectedDate).count / 7, id: \.self) { row in
                    HStack(spacing: 0) {
                        Divider()
                            .frame(height: 40)
                            .background(Color.gray)

                        ForEach(0..<7, id: \.self) { column in
                            let day = generateDaysInMonth(for: selectedDate)[row * 7 + column]
                            ZStack {
                                // 이벤트 표시
                                VStack(spacing: 5) {
                                    Spacer()
                                    HStack {
                                        ForEach(eventsForDate(day).prefix(3), id: \.self) { eventColor in
                                            Circle()
                                                .offset(x: 5, y: -10)
                                                .fill(eventColor)
                                                .frame(width: 6, height: 6)
                                        }
                                        Spacer()
                                    }
                                }

                                // 날짜 버튼
                                Button(action: {
                                    selectedDate = day
                                    onDateSelected(day)
                                }) {
                                    Text("\(Calendar.current.component(.day, from: day))")
                                        .font(.system(size: 12))
                                        .foregroundColor(Calendar.current.isDate(selectedDate, inSameDayAs: day) ? .white : .primary)
                                        .padding(5)
                                        .background(Calendar.current.isDate(selectedDate, inSameDayAs: day) ? Color.yellow : Color.clear)
                                        .clipShape(Circle())
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .offset(x: 3, y: 0) // 왼쪽 위로 이동
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay(
                                Divider()
                                    .background(Color.gray)
                                    .offset(x: gridWidth / 14), // 세로 구분선
                                alignment: .center
                            )
                        }
                    }
                    Divider()
                }
            }
            .frame(width: gridWidth) // Grid의 너비 고정
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .padding([.leading, .trailing], 1) // 양쪽 여백 조정
    }

    private func eventsForDate(_ date: Date) -> [Color] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.map { $0.color }
    }

    private func generateDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let startDay = calendar.component(.weekday, from: startOfMonth) - 1
        return Array(0..<(startDay + range.count)).map {
            calendar.date(byAdding: .day, value: $0 - startDay, to: startOfMonth) ?? Date()
        }
    }
}


func colorFromEnglishString(_ colorName: String) -> Color {
    switch colorName.lowercased() {
    case "red": return Color.red
    case "orange": return Color.orange
    case "yellow": return Color.yellow
    case "green": return Color.green
    case "blue": return Color.blue
    case "purple": return Color.purple
    default: return Color.black // 기본값
    }
}


func fetchEventsFromFirestore(for projectName: String, completion: @escaping ([Event]) -> Void) {
    let db = Firestore.firestore()
    
    // Firestore에서 events 컬렉션 가져오기
    db.collection("events")
        .whereField("projectName", isEqualTo: projectName)
        .getDocuments { snapshot, error in
            if let error = error {
                print("Firestore 데이터 가져오기 실패: \(error.localizedDescription)")
                completion([]) // 오류 발생 시 빈 배열 반환
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No events found for project: \(projectName)")
                completion([]) // 결과가 없을 경우 빈 배열 반환
                return
            }
            
            // Firestore 문서를 Event 객체로 매핑
            let events: [Event] = documents.compactMap { document in
                let data = document.data()
                guard
                    let title = data["title"] as? String,
                    let timestamp = data["date"] as? Timestamp,
                    let colorName = data["color"] as? String,
                    let location = data["location"] as? String,
                    let participants = data["participants"] as? [String]
                    
                else {
                    return nil
                }
                
                // Firestore에 저장된 색상을 Color로 변환
                let color = colorFromEnglishString(colorName)
                
                return Event(
                    projectName: projectName,
                    title: title,
                    date: timestamp.dateValue(),
                    location: location,
                    color: color,
                    participants: participants
                )
            }
            
            // 결과를 출력
            print("총 \(events.count)개의 이벤트를 가져왔습니다:")
            for event in events {
                print(" - Title: \(event.title), Date: \(event.date), Location: \(event.location), Participants: \(event.participants.joined(separator: ", "))")
            }
            
            // 콜백으로 이벤트 배열 반환
            completion(events)
        }
}







#Preview {
    CalendarView(projectName :"asdf")
        .environmentObject(NavigationManager())
}
