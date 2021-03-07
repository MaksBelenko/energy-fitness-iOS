//
//  AsyncOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 04/03/2021.
//

import Foundation
class OLD_AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "com.belenko.asyncoperation-\(UUID())", attributes: .concurrent)
    
    override var isAsynchronous: Bool {
        true
    }
    
    
    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            lockQueue.sync { _isExecuting }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            lockQueue.sync { _isFinished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        isFinished = false
        isExecuting = true
        main()
    }
    
    
    override func main() {
        fatalError("Subclasses must implement `execute` without overriding super.")
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}
