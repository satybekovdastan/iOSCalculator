//
//  DomainError.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

struct DomainError: Error, Equatable, Sendable {
    static func == (lhs: DomainError, rhs: DomainError) -> Bool {
        true
    }
    
    let statusCode: Int?
    let errorCode: ErrorCode?
    let message: String
    
    enum ErrorCode {
        
    }
    
    init(statusCode: Int? = nil, errorCode: ErrorCode? = nil, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }
}
