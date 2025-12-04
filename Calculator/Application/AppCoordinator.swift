//
//  AppCoordinator.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    
    enum AppScreen: Hashable {
        case calculator
        case main
    }
    
    // Хранит состояние аутентификации
    @Published var isAuthenticated: Bool = false
    
    // Управляет навигационным стеком внутри основного модуля
    @Published var path = NavigationPath()
    
    private var cancellables = Set<AnyCancellable>()
    
    func push(_ screen: AppScreen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
}
