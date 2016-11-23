//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

var ViewObserverObserversKey = "ViewObserverObserversKey"

/**
`ViewObserver` provides an entry point for observing:
- `Command`s
- `ComponentViewModel`s
- any other value
*/
public protocol ViewObserver : ComponentView {


    /**
    Takes the current value to create a `AnyObservation`.
     
    - parameter value: the value to be use.
     
    - returns: An `AnyObservation` that can be used from within a
    `ComponentView`.
    */
    func observe<AnyValue>(_ value: AnyValue) -> AnyObservation<AnyValue>

    /**
    Observes a `Command`.
     
    - parameter command: The `Command` to be observed.
     
    - returns: A `CommandObservation`.
    */
    func observe(_ value: Command) -> CommandObservation
    
    /**
     Observes a `ComponentViewModel`.

     - parameter viewModel: The `ComponentViewModel` to be observed.

     - returns: A `ViewModelObservation`.
     */
    func observe<ViewModelType: ComponentViewModel>(_ value: ViewModelType) -> ViewModelObservation<ViewModelType>
}

extension ComponentView {
    public func observe<AnyValue>(_ value: AnyValue) -> AnyObservation<AnyValue> {
        let observation = AnyObservation(value: value)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe(_ command: Command) -> CommandObservation {
        guard let observerSelf = self as? ViewObserver else { fatalError("The observed view does not implement the `ViewObservable` protocol") }
        
        let observation = CommandObservation(command: command, observer: observerSelf)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe<ViewModelType : ComponentViewModel>(_ value: ViewModelType) -> ViewModelObservation<ViewModelType> {
        let observation = ViewModelObservation<ViewModelType>(value: value, lifecycle: self.componentLifecycle!)

        self.observerCollection?.append(observation)
        
        return observation
    }
}

extension ComponentView {
    fileprivate typealias ObserverType = (observer: _Observation, onRemove: ((Void) -> Void)?)

    var observerCollection: ObservationCollection? {
        get {
            return self.associatedObjects[ViewObserverObserversKey] as? ObservationCollection
        }

        set { self.associatedObjects[ViewObserverObserversKey] = newValue }
    }
}
