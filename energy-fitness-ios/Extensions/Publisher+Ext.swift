//
//  Publisher+Ext.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/02/2021.
//

import Combine
import Foundation

extension Publisher where Self.Failure == Never {
    public func weakAssign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
    
    public func unownedAssign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [unowned object] (value) in
            object[keyPath: keyPath] = value
        }
    }
}


extension Publisher {
    // MARK: - tryFlatMap
    func tryFlatMap<Pub: Publisher>(_ transform: @escaping (Output) throws -> Pub) -> Publishers.FlatMap<AnyPublisher<Pub.Output, Error>, Self> {
        return flatMap({ input -> AnyPublisher<Pub.Output, Error> in
            do {
                return try transform(input)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            } catch {
                return Fail(outputType: Pub.Output.self, failure: error)
                    .eraseToAnyPublisher()
            }
        })
    }
}

extension Publisher {
    
    func validate(
            using validator: @escaping (Output) throws -> Void
        ) -> Publishers.TryMap<Self, Output> {
            tryMap { output in
                try validator(output)
                return output
            }
    }
    
    
    func mapToURL() -> Publishers.CompactMap<Self, URL> where Output == String {
        return compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
                .compactMap { URL(string: $0) }
    }

    func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
    
    /// Map to invert boolean
    func invert() -> Publishers.Map<Self, Bool> where Output == Bool {
        map { !$0 }
    }
    
    func tryUnwrap<T>() -> Publishers.TryMap<Self, T> where Output == Optional<T> {
        tryMap { try $0.unwrap() }
    }
    
    func log(
        _ message: @escaping (Self.Output) -> Any? = { (output: Self.Output) in return output },
        functionName: String = #function,
        fileName: String = #file,
        lineNumber: Int = #line
    ) -> AnyPublisher<Self.Output, Self.Failure> {
        return self.map {
            Log.debug(message: message($0) as! String, "", file: fileName, function: functionName, line: lineNumber)
            return $0
        }
        .eraseToAnyPublisher()
    }
}
