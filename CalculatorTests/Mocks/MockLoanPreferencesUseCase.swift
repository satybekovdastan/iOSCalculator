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
    
    var savedAmount: Double = 5000
    var savedTermIndex: Int = 1
    var savedTheme: LoanTheme = .dark
    
    var didSaveAmount = false
    var didSaveTermIndex = false
    var didSaveTheme = false
    
    func loadAmount() async -> Double { savedAmount }
    func loadTermIndex() async -> Int { savedTermIndex }
    func loadTheme() async -> LoanTheme { savedTheme }
    
    func saveAmount(_ amount: Double) {
        savedAmount = amount
        didSaveAmount = true
    }
    
    func saveTermIndex(_ index: Int) {
        savedTermIndex = index
        didSaveTermIndex = true
    }
    
    func saveTheme(_ theme: LoanTheme) {
        savedTheme = theme
        didSaveTheme = true
    }
}
