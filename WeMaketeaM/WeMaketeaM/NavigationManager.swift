//NavigationStack을 관리할 ViewModel

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func resetToRoot() {
        path = NavigationPath() // 루트로 돌아가는 동작
    }
}
