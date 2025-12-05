//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by DAS  on 4/12/25.
//
//
import Testing
import Foundation
@testable import Calculator

// MARK: - Tests
@Suite("LoanStore Tests")
@MainActor
struct LoanStoreTests {
    
    // MARK: - Setup Helper
    func makeSUT(
        appUseCase: MockApplyForLoanUseCase = MockApplyForLoanUseCase(),
        prefsUseCase: MockLoanPreferencesUseCase = MockLoanPreferencesUseCase(),
        initialState: LoanState = LoanState()
    ) -> LoanStore {
        let environment = LoanEnvironment(
            applyForLoan: appUseCase,
            preferences: prefsUseCase
        )
        return LoanStore(initialState: initialState, reducer: loanReducer, environment: environment)
    }
    

    @Test("Changing the amount updates state and triggers debounced save")
    func testUpdateAmountTriggersDebouncedSave() async throws {
        let mockPrefs = MockLoanPreferencesUseCase()
        let store = makeSUT(prefsUseCase: mockPrefs)
        
        store.send(.setAmount(7500))
        
        #expect(store.state.amount == 7500)
        #expect(mockPrefs.didSaveAmount == false)
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        
        #expect(mockPrefs.didSaveAmount, "Debounced saveAmount must have been called")
        #expect(mockPrefs.savedAmount == 7500, "Saved amount must match state")
    }
    
    @Test("Rapid changes to amount cancel previous saves")
    func testRapidUpdatesCancelPreviousSaves() async throws {

        let mockPrefs = MockLoanPreferencesUseCase()
        let store = makeSUT(prefsUseCase: mockPrefs)
        
        store.send(.setAmount(5100))
        try await Task.sleep(nanoseconds: 100_000_000)
        store.send(.setAmount(5200))
        try await Task.sleep(nanoseconds: 100_000_000)
        store.send(.setAmount(7800)) //
        
        #expect(mockPrefs.didSaveAmount == false)
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        
        #expect(mockPrefs.didSaveAmount, "Debounced save must be called")
        #expect(mockPrefs.savedAmount == 7800, "Must save only the final value (7800)")
    }
    
    // MARK: - Computed Properties Tests
    @Test(.timeLimit(.minutes(5)))
    func testTotalRepaymentCalculation() async {
        let store = makeSUT(initialState: LoanState(amount: 10000))
        
        let expectedTotal: Double = 10000 + 10000 * 0.15 // 11,500
        // 10,000 + (10,000 * 0.15) = 11,500

        #expect(store.totalRepaymentText == String(format: "%.2f", expectedTotal))
        #expect(store.interestRateText == "15.0%")
    }
    
    // MARK: - Asynchronous Actions Tests (apply)
    
    @Test("Successful loan application updates the result")
    func testApplySuccess() async throws {
        let mockAppUseCase = MockApplyForLoanUseCase()
        let expectedResult = LoanApplicationResult(id: 123) 
        
        mockAppUseCase.setResult(.success(expectedResult))
        let store = makeSUT(appUseCase: mockAppUseCase)
        
        store.send(.apply)
        
        #expect(store.state.isLoading == true)
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(store.state.isLoading == false)
        #expect(store.state.result == expectedResult)
        #expect(store.state.errorMessage == nil)
    }
    
    @Test("Failed loan application sets the error message")
    func testApplyFailure() async throws {
        let mockAppUseCase = MockApplyForLoanUseCase()
        let expectedError = DomainError(message: "Service Unavailable")
        
        mockAppUseCase.setResult(.failure(expectedError))
        let store = makeSUT(appUseCase: mockAppUseCase)
        
        store.send(.apply)
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        // Assert
        #expect(store.state.isLoading == false)
        #expect(store.state.result == nil)
    }
}
