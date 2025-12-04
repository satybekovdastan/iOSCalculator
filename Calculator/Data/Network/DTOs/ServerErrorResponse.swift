//
//  ServerErrorResponse.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

struct ServerErrorResponse: Decodable, Error {
    let message: String
}
