//
//  Publisher+Ext.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/02/2021.
//

import Combine

extension Publisher where Self.Failure == Never {
    public func assignOnWeak<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
    
    public func assignOnUnowned<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [unowned object] (value) in
            object[keyPath: keyPath] = value
        }
    }
}
