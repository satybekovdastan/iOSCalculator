//
//  ApplyForLoanUseCase.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol ApplyForLoanUseCase: Sendable {
    func apply(loan: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError>

}

final class DefaultApplyForLoanUseCase: ApplyForLoanUseCase, @unchecked Sendable {
    
    // MARK: Properties
    
    private let repository: ApplyForLoanRepository
    
    // MARK: Initialization
    
    init(repository: ApplyForLoanRepository) {
        self.repository = repository
    }
    
    func apply(loan: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError> {
        await repository.apply(request: loan)
    }
    
}
