//
//  LoanStore.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Combine
import Foundation

/// LoanCalculatorStore
/// Хранит состояние экрана калькулятора займа и управляет им в стиле UDF/Redux.
/// - Применяет `loanReducer` к `LoanState` по входящим `LoanAction`.
/// - Через `ApplyForLoanUseCase` отправляет заявку (`apply()`).
/// - Через `LoanPreferencesUseCase` загружает и сохраняет последние выборы (amount, term, theme).
/// - Предоставляет вычисляемые значения для UI: процентную ставку, сумму к возврату и дату возврата.
@MainActor
final class LoanStore: ObservableObject {
    
    @Published private(set) var state: LoanState
    
    private let useCase: ApplyForLoanUseCase
    private let prefsUseCase: LoanPreferencesUseCase
    private let reducer: (inout LoanState, LoanAction) -> Void
    
    private let interestRate: Double = 0.15 // 15%
    
    init(useCase: ApplyForLoanUseCase, prefsUseCase: LoanPreferencesUseCase) {
        self.useCase = useCase
        self.prefsUseCase = prefsUseCase
        self.state = LoanState()
        self.reducer = loanReducer
        
        Task { @MainActor in
            await loadPreferences()
        }
    }
    
    // MARK: - Preferences
    
    private func loadPreferences() async {
        state.theme = await prefsUseCase.loadTheme()
        let prefs = await prefsUseCase.load()
        state.amount = prefs.amount
        state.termIndex = prefs.termIndex
    }
    
    private func savePreferences() {
        let prefs = LoanPreferences(amount: state.amount, termIndex: state.termIndex)
        prefsUseCase.save(prefs)
    }
    
    private func saveThemePreference() {
        prefsUseCase.saveTheme(state.theme)
    }
    
    // MARK: - Actions
    
    func send(_ action: LoanAction) {
        switch action {
        case .setAmount, .setTermIndex:
            reducer(&state, action)
            savePreferences()
        case .setTheme:
            reducer(&state, action)
            saveThemePreference()
        case .apply:
            Task { @MainActor in
                await apply()
            }
        default:
            reducer(&state, action)
        }
    }
    
    private func apply() async {
        reducer(&state, .setLoading(true))
        
        let request = LoanApplicationRequest(
            amount: Int(state.amount),
            period: state.terms[state.termIndex],
            totalRepayment: totalRepaymentValue
        )
        
        let result = await useCase.apply(loan: request)
        switch result {
        case .success(let value):
            reducer(&state, .setResult(value))
        case .failure(let error):
            reducer(&state, .setErrorMessage(error.message))
        }
        
        reducer(&state, .setLoading(false))
    }
    
    // MARK: - Computed for UI
    
    var formattedAmount: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.groupingSeparator = ","
        fmt.maximumFractionDigits = 0
        return fmt.string(from: NSNumber(value: state.amount)) ?? "\(Int(state.amount))"
    }
    
    var totalRepaymentValue: Int {
        let total = state.amount + state.amount * interestRate
        return Int(total.rounded())
    }
    
    var totalRepaymentText: String {
        totalRepaymentValue.formatted(.number.grouping(.automatic))
    }
    
    var interestRateText: String {
        interestRate.formatted(.percent.precision(.fractionLength(0)))
    }
    
    var dueDateText: String {
        let days = state.terms[state.termIndex]
        let dueDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return dueDate.formatted(
            .dateTime
                .locale(Locale(identifier: "en_US"))
                .month(.abbreviated)
                .day()
                .year()
        )
    }
}
