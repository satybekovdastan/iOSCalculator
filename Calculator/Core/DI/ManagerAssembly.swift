//
//  ManagerAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

final class ManagerAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        
        container.register(UserDefaultsManager.self) { _ in
            DefaultUserDefaultsManager.shared
        }.inObjectScope(.container)
        
       container.register(BaseURLProvider.self) { _ in
            DefaultBaseURLProvider()
        }.inObjectScope(.container)
        
        container.register(NetworkManager.self) { resolver in
            guard let baseURLProvider = resolver.resolve(BaseURLProvider.self) else {
                fatalError("Enable to resolver BaseURLProvider")
            }
            
            return DefaultNetworkManager(
                baseURLProvider: baseURLProvider,
            )
        }.inObjectScope(.container)
    }
    
}
