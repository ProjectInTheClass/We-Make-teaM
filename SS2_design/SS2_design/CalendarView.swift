//
import SwiftUI

struct CalendarView: View{
    @State private var selectedDate: Date = Date()
    var projectName: String
    //@State private var eventsForSelectedDate: [Event] = []
    @State private var isPresentingAddEventView = false
    @EnvironmentObject var navigationManager: NavigationManager
    //State private var allEvents: [Event] = []
    
    var body: some View{
        Text(projectName)
    }
}
