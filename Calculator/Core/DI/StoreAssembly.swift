//
//  ViewModelAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

@MainActor
final class StoreAssembly: @preconcurrency Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(LoanCalculatorStore.self) { resolver in
            guard let userUseCase = resolver.resolve(LoanApplicationUseCase.self) else {
                fatalError("Assembler was unable to resolve LoanApplicationUseCase")
            }
            
            guard let prefsUseCase = resolver.resolve(LoanPreferencesUseCase.self) else {
                fatalError("Assembler was unable to resolve LoanPreferencesUseCase")
            }
            
            return LoanCalculatorStore(
                useCase:  userUseCase,
                prefsUseCase: prefsUseCase
            )
        }.inObjectScope(.transient)
    }
    
}
