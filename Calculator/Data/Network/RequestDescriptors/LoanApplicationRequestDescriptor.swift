//
//  LoanApplicationRequestDescriptor.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

enum LoanApplicationRequestDescriptor: RequestDescriptor {
    
    case loanApplication(body: LoanApplicationRequest)

    var path: String {
        switch self {
        case .loanApplication:
            "posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loanApplication: .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .loanApplication:
            nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .loanApplication(let body):
            [
                "amount": body.amount,
                "period": body.period,
                "totalRepayment": body.totalRepayment
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .loanApplication: false
        }
    }
    
}
