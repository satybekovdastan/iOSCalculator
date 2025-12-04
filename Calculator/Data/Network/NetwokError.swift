//
//  NetwokError.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case timeout
    case serverError(code: Int, errorCode: String?, message: String?)
    case decoding
    case authorizationFailed
}
