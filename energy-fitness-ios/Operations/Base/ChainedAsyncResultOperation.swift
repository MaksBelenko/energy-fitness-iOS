//
//  ChainedAsyncResultOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 04/03/2021.
//

import Foundation

protocol ChainedOperationOutputProviding {
    var output: Any? { get }
}

//extension AsyncResultOperation: ChainedOperationOutputProviding {
//    var output: Any? { try? result.get() }
//}

class ChainedAsyncResultOperation<Input, Output, Failure>: AsyncResultOperation<Output, Failure> where Failure: Error {

    private(set) var input: Input?

    init(input: Input? = nil) {
        self.input = input
        super.init()
    }

    override func start() {
        if input == nil {
            updateInputFromDependencies()
        }
        super.start()
    }

    private func updateInputFromDependencies() {
        self.input = try? dependencies.compactMap { (operation) -> ChainedAsyncResultOperation? in
            return operation as? ChainedAsyncResultOperation
        }.first?.result?.get() as? Input
    }

}
