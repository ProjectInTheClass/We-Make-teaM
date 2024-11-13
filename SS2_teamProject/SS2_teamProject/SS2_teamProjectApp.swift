//  Created by 김현경 on 11/11/24.
//

import SwiftUI

@main
struct SS2_teamProjectApp: App {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
    }
}
