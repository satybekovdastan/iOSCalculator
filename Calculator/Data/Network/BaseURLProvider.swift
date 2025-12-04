//
//  BaseURLProvider.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Foundation

protocol BaseURLProvider: Sendable {
    func url(for path: String) -> URL
}

final class DefaultBaseURLProvider: BaseURLProvider {
    
    // MARK: Properties
    
    private let baseURL: URL
    
    // MARK: Initialization

    init() {
        guard let string = Bundle.main.object(forInfoDictionaryKey: "API base URL") as? String,
              let url = URL(string: string) else {
            fatalError("Missing or invalid API base URL in Info.plist")
        }
        self.baseURL = url
    }
    
    // MARK: Public Methods

    func url(for path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }
    
}
