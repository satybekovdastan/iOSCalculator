//
//  UserDefaultManager.swift
//  Shopping
//
//  Created by Das
//
import Foundation
import os.lock 

protocol UserDefaultsManager: AnyObject {
    
    var theme: String { get set }
    var amount: Double { get set }
    var termIndex: Int { get set }
    
}

final class DefaultUserDefaultsManager: @unchecked Sendable, UserDefaultsManager {
    
    private let lock = OSAllocatedUnfairLock()
    
    static let shared = DefaultUserDefaultsManager()
    
    private init() {
        // Private initializer to ensure singleton pattern
    }

    private enum UserDefaultsKeys {
        static let amount = "amount_key"
        static let termIndex = "term_index_key"
        static let theme = "theme_key"
    }
    
    // MARK: - UserDefaultsManager Properties
    
    var amount: Double {
        get {
            lock.withLock {
                return UserDefaults.standard.double(forKey: UserDefaultsKeys.amount)
            }
        }
        set {
            lock.withLock {
                UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.amount)
            }
        }
    }
    
    var termIndex: Int {
        get {
            lock.withLock {
                return UserDefaults.standard.integer(forKey: UserDefaultsKeys.termIndex)
            }
        }
        set {
            lock.withLock {
                UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.termIndex)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var theme: String {
        get {
            lock.withLock {
                return UserDefaults.standard.string(forKey: UserDefaultsKeys.theme) ?? "system"
            }
        }
        set {
            lock.withLock {
                UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.theme)
            }
        }
    }
}
