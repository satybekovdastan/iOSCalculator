//
//  LoanCalculatorComponents.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

// MARK: - Reducer
import Combine
import Foundation

typealias LoanReducer = (inout LoanState, LoanAction, LoanEnvironment) -> Task<LoanAction, Never>?

func loanReducer(
    state: inout LoanState,
    action: LoanAction,
    environment: LoanEnvironment
) -> Task<LoanAction, Never>? {
    switch action {
    case let .setAmount(value):
        state.amount = min(max(value, state.amountRange.lowerBound),
                           state.amountRange.upperBound)
        return nil
    case let .setTermIndex(index):
        state.termIndex = min(max(0, index), state.terms.count - 1)
        return nil
    case .apply:
        state.isLoading = true
        let request = LoanApplicationRequest(
            amount: Int(state.amount),
            period: state.terms[state.termIndex],
            totalRepayment: Int(state.totalRepaymentValue)
        )
        
        return Task {
            let result = await environment.applyForLoan.apply(loan: request)
            
            switch result {
            case .success(let loanResult):
                return .setResult(loanResult)
            case .failure(let error):
                return .setErrorMessage(error.localizedDescription)
            }
        }
        
    case let .setResult(result):
        state.result = result
        state.errorMessage = nil
        state.isLoading = false
        return nil
        
    case let .setErrorMessage(error):
        state.errorMessage = error
        state.result = nil
        state.isLoading = false
        return nil
        
    case let .setLoading(isLoading):
        state.isLoading = isLoading
        return nil
        
    case let .setTheme(theme):
        state.theme = theme
        environment.preferences.saveTheme(theme)
        return nil
        
    }
}

struct LoanEnvironment : Sendable{
    var applyForLoan: ApplyForLoanUseCase
    var preferences: LoanPreferencesUseCase
    
    static func live(
        applyForLoan: ApplyForLoanUseCase,
        preferences: LoanPreferencesUseCase
    ) -> Self {
        LoanEnvironment(
            applyForLoan: applyForLoan,
            preferences: preferences
        )
    }
}
