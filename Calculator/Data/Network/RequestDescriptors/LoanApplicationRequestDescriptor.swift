//
//  LoanApplicationRequestDescriptor.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

enum LoanApplicationRequestDescriptor: RequestDescriptor {
    
    case apply(body: LoanApplicationRequest)

    var path: String {
        switch self {
        case .apply:
            "posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .apply: .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .apply:
            nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .apply(let body):
            [
                "amount": body.amount,
                "period": body.period,
                "totalRepayment": body.totalRepayment
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .apply: false
        }
    }
    
}
