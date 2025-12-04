//
//  LoanApplicationRequest.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

struct LoanApplicationRequest: Encodable {
    let amount: Int
    let period: Int
    let totalRepayment: Int
}
