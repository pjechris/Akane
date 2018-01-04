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
    public let context: Context
    fileprivate var disposes: [() -> ()] = []
    fileprivate var subObservers: [Int:ViewObserver] = [:]

    public init(container: ComponentContainer, context: Context) {
        self.container = container
        self.context = context
    }

    deinit {
        self.dispose()
    }

    /**
     Takes the current value to create a `AnyObservation`.

     - parameter value: the value to be use.

     - returns: An `AnyObservation` that can be used from within a
     `ComponentView`.
     */
    public func observe<AnyValue>(_ value: AnyValue) -> AnyObservation<AnyValue> {
        return AnyObservation(value: value, observer: self)
    }

    /**
     Observes a `ComponentViewModel`.

     - parameter viewModel: The `ComponentViewModel` to be observed.

     - returns: A `ViewModelObservation`.
     */
    public func observe<ViewModelType : ComponentViewModel>(_ value: ViewModelType) -> ViewModelObservation<ViewModelType> {
        return ViewModelObservation<ViewModelType>(value: value, container: self.container!, observer: self)
    }

    /// uses `identifier` to reuse a `ViewObserver` created with this id, or create a new one otherwise.
    /// - parameter identifier: identify ViewObserver instance
    /// - returns: a `ViewObserver` referenced by `identifier`
    public func observer(identifier: Int) -> ViewObserver {
        if let observer = self.subObservers[identifier] {
            return observer
        }

        let observer = ViewObserver(container: self.container!, context: context)

        self.subObservers[identifier] = observer

        return observer
    }

    public func dispose() {
        self.subObservers.forEach { $1.dispose() }
        self.disposes.forEach { $0() }
        self.disposes.removeAll()
    }

    public func add(disposable: @escaping () -> ()) {
        self.disposes.append(disposable)
    }
}
