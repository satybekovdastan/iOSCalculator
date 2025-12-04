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
            ViewAssembly(),
            ManagerAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            StoreAssembly()
        ], container: container)
        
        return assembler
    }()
}
