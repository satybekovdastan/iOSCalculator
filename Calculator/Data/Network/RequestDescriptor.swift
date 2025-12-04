//
//  RequestDescriptor.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol RequestDescriptor {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var requiresAuth: Bool { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
