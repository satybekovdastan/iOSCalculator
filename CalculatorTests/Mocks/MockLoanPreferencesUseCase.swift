//
//  MockLoanPreferencesUseCase.swift
//  Calculator
//
//  Created by DAS  on 5/12/25.
//

// MARK: - Mocks

import Testing
import Foundation
@testable import Calculator

final class MockLoanPreferencesUseCase: LoanPreferencesUseCase, @unchecked Sendable {
    var savedTheme: LoanTheme = .dark
    var savedPrefs: LoanPreferences = LoanPreferences(amount: 5000, termIndex: 1)
    var didSavePrefs = false
    var didSaveTheme = false
    
    func loadTheme() async -> LoanTheme { savedTheme }
    func load() async -> LoanPreferences { savedPrefs }
    
    func save(_ prefs: LoanPreferences) {
        savedPrefs = prefs
        didSavePrefs = true
    }
    
    func saveTheme(_ theme: LoanTheme) {
        savedTheme = theme
        didSaveTheme = true
    }
}
