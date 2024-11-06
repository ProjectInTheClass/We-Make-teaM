//프로젝트 홈화면 -> 캘린
import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date? = nil
    @State private var eventsForSelectedDate: [CustomEvent] = []
    @State private var isPresentingAddEventView = false
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var allEvents: [CustomEvent] = []

    var body: some View {
        VStack {
            // 상단 바
            HStack {
                Spacer()
                Button(action: {
                    navigationManager.resetToRoot()
                }) {
                    Text("WMM")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 10)
            }
            .padding()

            // DatePicker
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
            
            // 일정 정보 표시
            if let date = selectedDate, !eventsForSelectedDate.isEmpty {
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
                AddEventView(events: $allEvents)
                    .onDisappear {
                        if let date = selectedDate {
                            loadEvents(for: date)
                        }
                    }
            }

            // 하단 네비게이션 바
            HStack {
                NavigationLink(destination: CalendarView()) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("캘린더")
                    }
                }
                
                Spacer()
                NavigationLink(destination: ProjectHomeView(projectName: "프로젝트 홈")) {
                    VStack {
                        Image(systemName: "house")
                        Text("홈")
                    }
                }
                Spacer()
                NavigationLink(destination: MySubmissionView()) {
                    VStack {
                        Image(systemName: "doc.text")
                        Text("나의 제출")
                    }
                }
                Spacer()
                NavigationLink(destination: ParticipationRankingView(teamName: "소프트웨어 스튜디오2")) {
                    VStack {
                        Image(systemName: "person.3")
                        Text("참여순위")
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
        .onAppear {
            loadDummyEvents() // 더미 데이터를 초기 로드
        }
        .navigationTitle("전체 일정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadEvents(for date: Date) {
        eventsForSelectedDate = allEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func loadDummyEvents() {
        allEvents.removeAll()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let eventsData = [
            ("2024-11-05", "더미데이터 작성", "회의실 A", Color.blue, ["A", "B"]),
            ("2024-11-12", "Data schema 짜기", "온라인", Color.green, ["B", "C"]),
            ("2024-11-19", "git 올리기", "사무실 2층", Color.orange, ["A", "C"])
        ]
        
        for (dateString, title, location, color, participants) in eventsData {
            if let date = formatter.date(from: dateString) {
                allEvents.append(CustomEvent(title: title, date: date, location: location, color: color, participants: participants))
            }
        }

        if let selectedDate = selectedDate {
            loadEvents(for: selectedDate)
        }
    }
}

#Preview {
    AddEventView(events: .constant([]))
}
