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

/**
`ViewObserver` provides an entry point for observing:
- `Command`s
- `ComponentViewModel`s
- any other value
*/
public protocol ViewObserver : class, HasAssociatedObjects {
    /**
    Takes the current value to create a `AnyObservation`. No real observation is made as value never changes.
     
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

var ViewObserverObserversKey = "ViewObserverObserversKey"
extension ViewObserver {
    private typealias ObserverType = (observer: _Observation, onRemove: (Void -> Void)?)

    var observerCollection: ObservationCollection? {
        get {
            return self.associatedObjects[ViewObserverObserversKey] as? ObservationCollection
        }

        set { self.associatedObjects[ViewObserverObserversKey] = newValue }
    }
}
