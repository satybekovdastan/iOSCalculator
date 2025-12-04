//
//  LoanCalculatorRepository.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol ApplyForLoanRepository {
    func apply(request: LoanApplicationRequest) async ->  Result<LoanApplicationResult, DomainError>
}
