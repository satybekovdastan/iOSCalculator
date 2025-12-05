//
//  LoanCalculatorRepository.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol LoanPreferencesRepository {
    func loadTheme() async ->  LoanTheme
    func loadAmount() async -> Double
    func loadTermIndex() async -> Int
    func saveAmount(_ prefs: Double)
    func saveTermIndex(_ prefs: Int)
    func saveTheme(theme: LoanTheme)
}
