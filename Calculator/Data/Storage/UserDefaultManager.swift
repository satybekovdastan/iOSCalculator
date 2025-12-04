//
//  UserDefaultManager.swift
//  Shopping
//
//  Created by Das
//

import Foundation

import Foundation

protocol UserDefaultsManager: AnyObject {
    
    var theme: String { get set}
    var amount: Double { get set}
    var termIndex: Int { get set}
    
}

final class DefaultUserDefaultsManager: UserDefaultsManager {
    
    nonisolated(unsafe) static let shared = DefaultUserDefaultsManager()
    
    private init() {
        // Private initializer to ensure singleton pattern
    }

    private enum UserDefaultsKeys {
        static let amount = "amount_key"
        static let termIndex = "term_index_key"
        static let theme = "theme_key"
    }
    
    @UserDefault(UserDefaultsKeys.amount, defaultValue: 0)
    var amount: Double
    
    @UserDefault(UserDefaultsKeys.termIndex, defaultValue: 0)
    var termIndex: Int
    
    @UserDefault(UserDefaultsKeys.theme, defaultValue: "system")
    var theme: String
    
  
}


@propertyWrapper
final class UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private var cachedValue: T?

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let cachedValue = cachedValue {
                return cachedValue
            }
            let value = UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            cachedValue = value
            return value
        }
        set {
            cachedValue = newValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

