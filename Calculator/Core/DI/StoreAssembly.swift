//
//  StoreAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

@MainActor
final class StoreAssembly: @preconcurrency Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(LoanStore.self) { resolver in
            guard let applyUseCase = resolver.resolve(ApplyForLoanUseCase.self) else {
                fatalError("Assembler was unable to resolve ApplyForLoanUseCase")
            }
            
            guard let prefsUseCase = resolver.resolve(LoanPreferencesUseCase.self) else {
                fatalError("Assembler was unable to resolve LoanPreferencesUseCase")
            }
            
            let environment = LoanEnvironment.live(
                applyForLoan: applyUseCase,
                preferences: prefsUseCase
            )
            
            return LoanStore(
                reducer: loanReducer,  
                environment: environment
            )
        }.inObjectScope(.transient)

    }
    
}
