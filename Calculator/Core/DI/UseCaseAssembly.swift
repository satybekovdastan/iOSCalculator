//
//  UseCaseAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

final class UseCaseAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
    
        container.register(ApplyForLoanUseCase.self) { resolver in
            guard let repository = resolver.resolve(ApplyForLoanRepository.self) else {
                fatalError("Unable to resolve LoanApplicationRepository")
            }
            
            return DefaultApplyForLoanUseCase(repository: repository)
        }
        
        container.register(LoanPreferencesUseCase.self) { resolver in
            guard let repository = resolver.resolve(LoanPreferencesRepository.self) else {
                fatalError("Unable to resolve LoanPreferencesRepository")
            }
            
            return DefaultLoanPreferencesUseCase(repository: repository)
        }
    }
    
}
