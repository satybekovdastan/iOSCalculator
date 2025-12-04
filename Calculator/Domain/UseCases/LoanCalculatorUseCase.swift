//
//  LoanApplicationUseCase.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol LoanApplicationUseCase: Sendable {
    func apply(loan: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError>

}

final class DefaultLoanApplicationUseCase: LoanApplicationUseCase, @unchecked Sendable {
    
    // MARK: Properties
    
    private let repository: LoanApplicationRepository
    
    // MARK: Initialization
    
    init(repository: LoanApplicationRepository) {
        self.repository = repository
    }
    
    func apply(loan: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError> {
        await repository.loanApplication(request: loan)
    }
    
}
