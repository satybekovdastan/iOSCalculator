//
//  Assembler+Shared.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

extension Assembler {
    @MainActor
    static let shared: Assembler = {
        let container = Container()
        
        let assembler = Assembler([
            ManagerAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            StoreAssembly(),
            ViewAssembly()
        ], container: container)
        
        return assembler
    }()
}
