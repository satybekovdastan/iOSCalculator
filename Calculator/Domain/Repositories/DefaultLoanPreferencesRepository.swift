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
    
    func loadAmount() async -> Double {
        userDefaultManager.amount.isZero ? 5000 : userDefaultManager.amount
    }
    
    func loadTermIndex() async -> Int {
        userDefaultManager.termIndex
    }
    
    func saveAmount(_ prefs: Double) {
        userDefaultManager.amount = prefs
    }
    
    func saveTermIndex(_ prefs: Int) {
        userDefaultManager.termIndex = prefs
    }
    
    func loadTheme() async -> LoanTheme {
        let themeRaw = userDefaultManager.theme 
        let theme = LoanTheme(rawValue: themeRaw)!
        return theme
    }

    func saveTheme(theme: LoanTheme) {
        userDefaultManager.theme = theme.rawValue
    }
    
}
