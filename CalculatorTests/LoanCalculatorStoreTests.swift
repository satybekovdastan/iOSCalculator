//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by DAS  on 4/12/25.
//

import Testing
import Foundation
@testable import Calculator


// MARK: - Tests

@Suite("LoanCalculatorStore Tests")
@MainActor
struct LoanCalculatorStoreTests {
    
    func makeSUT(
        appUseCase: MockLoanApplicationUseCase = MockLoanApplicationUseCase(),
        prefsUseCase: MockLoanPreferencesUseCase = MockLoanPreferencesUseCase()
    ) -> LoanCalculatorStore {
        return LoanCalculatorStore(useCase: appUseCase, prefsUseCase: prefsUseCase)
    }
    
    @Test("Initialization loads saved preferences and theme")
    func testInitializationLoadsPreferences() async throws {
        let mockAppUseCase = MockLoanApplicationUseCase()
        let mockPrefsUseCase = MockLoanPreferencesUseCase()
        
        mockPrefsUseCase.savedPrefs = LoanPreferences(amount: 9999, termIndex: 2)
        mockPrefsUseCase.savedTheme = .dark
        
        let store = makeSUT(appUseCase: mockAppUseCase, prefsUseCase: mockPrefsUseCase)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(store.state.amount == 9999)
        #expect(store.state.termIndex == 2)
        #expect(store.state.theme == .dark)
    }
    
    @Test("Changing the amount updates state and saves preferences")
    func testUpdateAmountSavesPrefs() {
        let mockPrefs = MockLoanPreferencesUseCase()
        let store = makeSUT(prefsUseCase: mockPrefs)
        
        store.send(.setAmount(7500))
        
        #expect(store.state.amount == 7500)
        #expect(mockPrefs.savedPrefs.amount == 7500)
        #expect(mockPrefs.didSavePrefs)
    }
    
    @Test(.timeLimit(.minutes(5)))
    func testTotalRepaymentCalculation() async {
        let store = makeSUT()
        store.send(.setAmount(10000))
        // 10,000 + (10,000 * 0.15) = 11,500
        
        #expect(store.totalRepaymentValue == 11500)
        #expect(store.interestRateText == "15\u{00A0}%")
    }
    
    @Test("Successful loan application updates the result")
    func testApplySuccess() async throws {
        let mockAppUseCase = MockLoanApplicationUseCase()
        let expectedResult = LoanApplicationResult(id: 123)
        
        mockAppUseCase.setResult(.success(expectedResult))
        let store = makeSUT(appUseCase: mockAppUseCase)
        
        store.send(.apply)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(store.state.isLoading == false)
        #expect(store.state.result == expectedResult)
        #expect(store.state.errorMessage == nil)
    }
    
    @Test("Failed loan application sets the error message")
    func testApplyFailure() async throws {
        let mockAppUseCase = MockLoanApplicationUseCase()
        let expectedError = DomainError(message: "Service Unavailable")
        
        mockAppUseCase.setResult(.failure(expectedError))
        let store = makeSUT(appUseCase: mockAppUseCase)
        
        store.send(.apply)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(store.state.isLoading == false)
        #expect(store.state.result == nil)
        #expect(store.state.errorMessage == "Service Unavailable")
    }
}
