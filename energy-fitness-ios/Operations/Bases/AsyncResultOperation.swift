//
//  AsyncResultOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 04/03/2021.
//

import Foundation


class AsyncResultOperation<Success, Failure>: AsyncOperation where Failure: Error {

    private(set) var result: Result<Success, Failure>? {
        didSet {
            guard let result = result else { return }
            onResult?(result)
        }
    }

    var onResult: ((_ result: Result<Success, Failure>) -> Void)?

    override func finish() {
        fatalError("You should use finish(with:) to ensure a result")
    }

    func finish(with result: Result<Success, Failure>) {
        self.result = result
        super.finish()
    }

    override func cancel() {
        fatalError("You should use cancel(with:) to ensure a result")
    }

    func cancel(with error: Failure) {
        result = .failure(error)
        super.cancel()
    }
}
