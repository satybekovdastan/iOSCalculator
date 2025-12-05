//
//  LoanState.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//


// MARK: - State

enum LoanTheme: String, CaseIterable {
    case system   
    case light
    case dark
}

enum Constants {
    static let percent: Double = 0.15 // 15%
}

struct LoanState: Equatable { 
    var amount: Double = 20_000
    var termIndex: Int = 1
    let amountRange: ClosedRange<Double> = 5_000...50_000
    let terms: [Int] = [7, 14, 21, 28]
    var isLoading: Bool = false
    var result: LoanApplicationResult? = nil
    var errorMessage: String? = nil
    var theme: LoanTheme = .system
}

extension LoanState {
    var totalRepaymentValue: Double {
        amount + amount * Constants.percent
    }
}
