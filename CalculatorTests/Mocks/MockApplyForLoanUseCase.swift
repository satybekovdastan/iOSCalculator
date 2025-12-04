//
//  MockLoanApplicationUseCase.swift
//  Calculator
//
//  Created by DAS  on 5/12/25.
//

// MARK: - Mocks

import Testing
import Foundation
@testable import Calculator

final class MockApplyForLoanUseCase: ApplyForLoanUseCase, @unchecked Sendable {
    var resultToReturn: Result<LoanApplicationResult, DomainError>?
    
    func apply(loan: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError> {
        try? await Task.sleep(nanoseconds: 10_000_000)
        guard let result = resultToReturn else {
            return .failure(DomainError(message: "Mock result not set"))
        }
        return result
    }
    
    func setResult(_ result: Result<LoanApplicationResult, DomainError>) {
        self.resultToReturn = result
    }
}
