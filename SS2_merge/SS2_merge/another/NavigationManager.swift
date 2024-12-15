//
//  NavigationMagnager.swift
//  SS2_design
//
import SwiftUI

class NavigationManager: ObservableObject {
    // 네비게이션 스택의 경로를 관리하는 배열
    @Published var path: [UUID] = []
    
    // 루트 화면으로 돌아가기
    func resetToRoot() {
        path.removeAll()
    }
}

