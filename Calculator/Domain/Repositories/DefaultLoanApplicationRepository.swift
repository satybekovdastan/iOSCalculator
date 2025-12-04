//
//  DefaultLoanCalculatorRepository.swift.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

final class DefaultLoanApplicationRepository: BaseRepository, LoanApplicationRepository {
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    
    // MARK: Initialization
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    
    func loanApplication(request: LoanApplicationRequest) async -> Result<LoanApplicationResult, DomainError> {
        let request = LoanApplicationRequestDescriptor.loanApplication(body: request)
        
        do {
            let response: LoanApplicationResponse = try await networkManager.performRequest(
                request,
                allowRetry: false
            )
            return .success(mapSendCode(response))
        } catch {
            return .failure(mapError(error))
        }
    }

    
    // MARK: Private Methods
    
    private func mapSendCode(_ response: LoanApplicationResponse) -> LoanApplicationResult {
        LoanApplicationResult(
            id: response.id
        )
    }
    
}
