//사용한 더미데이터들

import SwiftUI

//일정더미 데이터 
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
