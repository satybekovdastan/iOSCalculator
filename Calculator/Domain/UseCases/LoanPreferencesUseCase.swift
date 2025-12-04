//
//  LoanPreferencesUseCase.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

struct LoanPreferences {
    let amount: Double
    let termIndex: Int
}

protocol LoanPreferencesUseCase: Sendable {
    func load() async -> LoanPreferences
    func save(_ prefs: LoanPreferences)
    func loadTheme() async -> LoanTheme
    func saveTheme(_ theme: LoanTheme)
}

final class DefaultLoanPreferencesUseCase: LoanPreferencesUseCase, @unchecked Sendable {
    
    private let repository: LoanPreferencesRepository
    
    init(repository: LoanPreferencesRepository) {
        self.repository = repository
    }
    
    func load() async -> LoanPreferences {
        return await repository.load()
    }
    
    func save(_ prefs: LoanPreferences) {
        repository.save(prefs: prefs)
    }
    
    func loadTheme() async -> LoanTheme {
        return await repository.loadTheme()
    }
    
    func saveTheme(_ theme: LoanTheme) {
        repository.saveTheme(theme: theme)
    }
}
