//
//  BaseRepository.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

class BaseRepository {
    
    func mapError(_ error: Error) -> DomainError {
        let unknownErrorMessage = String(localized: "Something went wrong. Please try again later.")
        
        if let networkError = error as? NetworkError,
           case let .serverError(code, _, message) = networkError {
            return DomainError(
                statusCode: code,
                errorCode: nil,
                message: message ?? unknownErrorMessage
            )
        } else {
            return DomainError(message: unknownErrorMessage)
        }
    }
    
}
