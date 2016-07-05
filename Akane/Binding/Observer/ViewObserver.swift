//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond
import HasAssociatedObjects

var ViewObserverObserversKey = "ViewObserverObserversKey"
var ViewObserverLifecycleAttr = "ViewObserverLifecycleAttr"

/**
`ViewObserver` provides an entry point for observing:
- `Command`s
- `ComponentViewModel`s
- any other value
*/
public protocol ViewObserver : class, HasAssociatedObjects {


    /**
    Takes the current value to create a `AnyObservation`.
     
    - parameter value: the value to be use.
     
    - returns: An `AnyObservation` that can be used from within a
    `ComponentView`.
    */
    func observe<AnyValue>(value: AnyValue) -> AnyObservation<AnyValue>

    /**
    Observes a `Command`.
     
    - parameter command: The `Command` to be observed.
     
    - returns: A `CommandObservation`.
    */
    func observe(value: Command) -> CommandObservation
    
    /**
     Observes a `ComponentViewModel`.

     - parameter viewModel: The `ComponentViewModel` to be observed.

     - returns: A `ViewModelObservation`.
     */
    func observe<ViewModelType: ComponentViewModel>(value: ViewModelType) -> ViewModelObservation<ViewModelType>
}

extension ViewObserver {
    public internal(set) weak var componentLifecycle: Lifecycle? {
        get {
            guard let weakValue = self.associatedObjects[ViewObserverLifecycleAttr] as? AnyWeakValue else {
                return nil
            }

            return weakValue.value as? Lifecycle
        }
        set { self.associatedObjects[ViewObserverLifecycleAttr] = AnyWeakValue(newValue) }
    }

    public func observe<AnyValue>(value: AnyValue) -> AnyObservation<AnyValue> {
        let observation = AnyObservation(value: value)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe(value: Command) -> CommandObservation {
        let observation = CommandObservation(command: value)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe<ViewModelType : ComponentViewModel>(value: ViewModelType) -> ViewModelObservation<ViewModelType> {
        let observation = ViewModelObservation<ViewModelType>(value: value, lifecycle: self.componentLifecycle!)

        self.observerCollection?.append(observation)
        
        return observation
    }
}

extension ViewObserver {
    private typealias ObserverType = (observer: _Observation, onRemove: (Void -> Void)?)

    var observerCollection: ObservationCollection? {
        get {
            return self.associatedObjects[ViewObserverObserversKey] as? ObservationCollection
        }

        set { self.associatedObjects[ViewObserverObserversKey] = newValue }
    }
}
