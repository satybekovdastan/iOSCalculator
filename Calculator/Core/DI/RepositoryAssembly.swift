//
//  RepositoryAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

final class RepositoryAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        
        container.register(LoanApplicationRepository.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkManager.self) else {
                fatalError("Unable to resolver NetworkManager")
            }
            
            return DefaultLoanApplicationRepository(networkManager: networkManager)
        }
        
        container.register(LoanPreferencesRepository.self) { resolver in
            guard let userDefaultManager = resolver.resolve(UserDefaultsManager.self) else {
                fatalError("Unable to resolver UserDefaultsManager")
            }
            return DefaultLoanPreferencesRepository(userDefaultManager: userDefaultManager)
        }
    }
    
}
