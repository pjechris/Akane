//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

/**
 `ViewObserver` provides an entry point for observing:
 - `Command`s
 - `ComponentViewModel`s
 - any other value
 */
public class ViewObserver {
    public private(set) weak var container: ComponentContainer?
    fileprivate var disposes: [(Void) -> ()] = []

    init(container: ComponentContainer) {
        self.container = container
    }

    /**
     Takes the current value to create a `AnyObservation`.

     - parameter value: the value to be use.

     - returns: An `AnyObservation` that can be used from within a
     `ComponentView`.
     */
    public func observe<AnyValue>(_ value: AnyValue) -> AnyObservation<AnyValue> {
        return AnyObservation(value: value)
    }

    /**
     Observes a `ComponentViewModel`.

     - parameter viewModel: The `ComponentViewModel` to be observed.

     - returns: A `ViewModelObservation`.
     */
    public func observe<ViewModelType : ComponentViewModel>(_ value: ViewModelType) -> ViewModelObservation<ViewModelType> {
        return ViewModelObservation<ViewModelType>(value: value, container: self.container!)
    }

    public func dispose() {
        self.disposes.forEach { $0() }
        self.disposes.removeAll()
    }

    public func add(disposable: @escaping (Void) -> ()) {
        self.disposes.append(disposable)
    }
}
