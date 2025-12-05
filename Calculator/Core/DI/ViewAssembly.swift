//
//  ViewAssembly.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import Swinject

final class ViewAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {

        container.register(LoanView.self) { r in
            guard let store = r.resolve(LoanStore.self) else {
                fatalError("Unable to resolve LoanStore")
            }
            return LoanView(store: store)
        }.inObjectScope(.transient)
        
    }
 
}
