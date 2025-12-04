//
//  LoanCalculatorRepository.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol LoanPreferencesRepository {
    func load() async ->  LoanPreferences
    func loadTheme() async ->  LoanTheme
    func save(prefs: LoanPreferences)
    func saveTheme(theme: LoanTheme)
}
