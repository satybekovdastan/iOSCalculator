//
//  DefaultLoanCalculatorRepository.swift.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

final class DefaultApplyForLoanRepository: BaseRepository, ApplyForLoanRepository {
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    
    // MARK: Initialization
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    
    func apply(request: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError> {
        let request = LoanApplicationRequestDescriptor.apply(body: request)
        
        do {
            let response: LoanApplicationResponse = try await networkManager.performRequest(
                request,
                allowRetry: false
            )
            return .success(mapApply(response))
        } catch {
            return .failure(mapError(error))
        }
    }

    
    // MARK: Private Methods
    
    private func mapApply(_ response: LoanApplicationResponse) -> LoanApplicationResult {
        LoanApplicationResult(
            id: response.id
        )
    }
    
}
