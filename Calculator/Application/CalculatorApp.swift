//
//  CalculatorApp.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI
import Swinject

@main
struct CalculatorApp: App {
    
    // MARK: Properties
    
    @StateObject private var coordinator: AppCoordinator
    
    // MARK: Initialization
    
    init() {
        self._coordinator = StateObject(wrappedValue: AppCoordinator())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
