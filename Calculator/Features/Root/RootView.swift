//
//  RootView.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI
import Swinject

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        Assembler.shared.resolver.resolve(LoanCalculatorView.self)
        
        /* На будущее если потребуется ароверка на авторизацию
        if coordinator.isAuthenticated {
            MainTabView()
        } else {
            Assembler.shared.resolver.resolve(LoanCalculatorView.self)
        }
         */
        
    }
}

#Preview {
    RootView()
}
