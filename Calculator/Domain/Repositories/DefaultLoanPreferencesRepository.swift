//
//  DefaultLoanPreferencesRepository.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

final class DefaultLoanPreferencesRepository: BaseRepository, LoanPreferencesRepository {
    
    // MARK: Properties
    
    private let userDefaultManager: UserDefaultsManager
    
    // MARK: Initialization
    
    init(userDefaultManager: UserDefaultsManager) {
        self.userDefaultManager = userDefaultManager
    }
    
    // MARK: Public Methods
    
    func load() async -> LoanPreferences {
        let amount = userDefaultManager.amount.isZero ? 5000 : userDefaultManager.amount
        let term = userDefaultManager.termIndex.isMultiple(of: 2) ? 3 : 1
        
        return LoanPreferences(amount: Double(amount), termIndex: term)
    }
    
    func loadTheme() async -> LoanTheme {
        let themeRaw = userDefaultManager.theme 
        let theme = LoanTheme(rawValue: themeRaw)!
        return theme
    }
    
    func save(prefs preferred: LoanPreferences) {
        userDefaultManager.amount = preferred.amount
        userDefaultManager.termIndex = preferred.termIndex
    }
    
    func saveTheme(theme: LoanTheme) {
        userDefaultManager.theme = theme.rawValue
    }
    
}
