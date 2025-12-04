//
//  LoanCalculatorComponents.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//



// MARK: - Reducer

func loanReducer(state: inout LoanState, action: LoanAction) {
    switch action {
    case let .setAmount(value):
        state.amount = min(max(value, state.amountRange.lowerBound),
                           state.amountRange.upperBound)

    case let .setTermIndex(index):
        let maxIndex = state.terms.count - 1
        state.termIndex = min(max(0, index), maxIndex)

    case let .setLoading(isLoading):
        state.isLoading = isLoading
    case let .setResult(result):
        state.result = result
        state.errorMessage = nil
    case let .setErrorMessage(error):
        state.errorMessage = error
        state.result = nil
    case .apply:
        break
    case let .setTheme(theme):
           state.theme = theme
       }
}



