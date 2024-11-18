//프로젝트 생성 홈으로 이동하는 NavigationStack을 관리하는 ViewModel

import SwiftUI

class NavigationManager: ObservableObject{
    @Published var path = NavigationPath()
    
    func resetToRoot(){
        path = NavigationPath()
    }
}
