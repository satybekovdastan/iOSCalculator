//
//  LoanStore.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Combine
import Foundation

@MainActor
final class LoanStore: ObservableObject {
    @Published var state: LoanState = LoanState()
    
    private let reducer: LoanReducer
    private let environment: LoanEnvironment
    
    private var amountSaveTask: Task<Void, Never>?
    private var termIndexSaveTask: Task<Void, Never>?
    private var themeSaveTask: Task<Void, Never>?

    init(initialState: LoanState = LoanState(), reducer: @escaping LoanReducer, environment: LoanEnvironment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: LoanAction) {
        guard let task = reducer(&state, action, environment) else {
            handleSyncAction(action)  
            return
        }
        
        Task { @MainActor in
            let newAction = await task.value
            self.send(newAction)
        }
    }
    
    private func handleSyncAction(_ action: LoanAction) {
        switch action {
        case .setAmount:
            debounceSaveAmount()
            
        case .setTermIndex:
            debounceSaveTermIndex()
            
        case .setTheme:
            debounceSaveTheme()
            
        default:
            break
        }
    }
    
    private func debounceSaveAmount() {
        amountSaveTask?.cancel()
        amountSaveTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if !Task.isCancelled {
                environment.preferences.saveAmount(state.amount)
            }
        }
    }
    
    private func debounceSaveTermIndex() {
        termIndexSaveTask?.cancel()
        termIndexSaveTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if !Task.isCancelled {
                environment.preferences.saveTermIndex(state.termIndex)
            }
        }
    }
    
    private func debounceSaveTheme() {
        themeSaveTask?.cancel()
        themeSaveTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if !Task.isCancelled {
                environment.preferences.saveTheme(state.theme)
            }
        }
    }
    
    func loadPreferences() {
         Task { @MainActor in
             async let amount = environment.preferences.loadAmount()
             async let termIndex = environment.preferences.loadTermIndex()
             async let theme = environment.preferences.loadTheme()

             self.state.amount = await amount
             self.state.termIndex = await termIndex
             self.state.theme = await theme
         }
     }
}


extension LoanStore {
    var formattedAmount: String {
        String(format: "%.0f", state.amount)
    }
    
    var interestRateText: String {
        "15.0%"
    }
    
    var totalRepaymentText: String {
        let total = totalRepaymentValue
        return String(format: "%.2f", total)
    }
    
    var totalRepaymentValue: Double {
        state.amount + state.amount * Constants.percent
    }
    
    var dueDateText: String {
        let calendar = Calendar.current
        let dueDate = calendar.date(
            byAdding: .day,
            value: state.terms[state.termIndex],
            to: Date()
        )!
       
        return dueDate.formatted(
            .dateTime
                .locale(Locale(identifier: "en_US"))
                .month(.abbreviated)
                .day()
                .year()
        )
    }
}
