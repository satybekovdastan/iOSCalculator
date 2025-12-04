//
//  LoanState.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//


// MARK: - State

enum LoanTheme: String, CaseIterable {
    case system     // как в настройках устройства
    case light
    case dark
}

struct LoanState {
    var amount: Double = 20_000
    var termIndex: Int = 1          // индекс в массиве terms
    let amountRange: ClosedRange<Double> = 5_000...50_000
    let terms: [Int] = [7, 14, 21, 28]
    var isLoading: Bool = false
    var result: LoanApplicationResult? = nil
    var errorMessage: String? = nil
    var theme: LoanTheme = .system
}
