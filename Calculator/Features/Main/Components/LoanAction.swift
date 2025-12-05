//
//  LoanAction.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

// MARK: - Action

enum LoanAction {
    case setAmount(Double)
    case setTermIndex(Int)
    case apply
    case setLoading(Bool)
    case setResult(LoanApplicationResult?)
    case setErrorMessage(String?)
    case setTheme(LoanTheme)
}
