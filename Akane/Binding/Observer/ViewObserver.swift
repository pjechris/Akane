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
    Takes the current value to create a `AnyObserver`. No real observation is made as value never changes.
     
    - parameter value: the value to be use.
     
    - returns: An `AnyObserver` that can be used from within a
    `ComponentView`.
    */
    func observe<AnyValue>(value: AnyValue) -> AnyObserver<AnyValue>

    /**
    Observes a `Command`.
     
    - parameter command: The `Command` to be observed.
     
    - returns: A `CommandObserver`.
    */
    func observe(value: Command) -> CommandObserver
    
    /**
     Observes a `ComponentViewModel`.

     - parameter viewModel: The `ComponentViewModel` to be observed.

     - returns: A `ViewModelObserver`.
     */
    func observe<ViewModelType: ComponentViewModel>(value: ViewModelType) -> ViewModelObserver<ViewModelType>
}

var ViewObserverObserversKey = "ViewObserverObserversKey"
extension ViewObserver where Self : HasAssociatedObjects {
    private typealias ObserverType = (observer: _Observer, onRemove: (Void -> Void)?)

    var count: Int { return self.observers?.count ?? 0 }

    private var observers: [ObserverType]? {
        get { return self.associatedObjects[ViewObserverObserversKey] as? [ObserverType] }
        set { self.associatedObjects[ViewObserverObserversKey] = newValue }
    }
    

    func append(observer: _Observer, onRemove: (Void -> Void)? = nil) {
        var observers = self.observers ?? []

        observers.append((observer: observer, onRemove: onRemove))
        self.observers = observers
    }

    func removeAllObservers() {
        if let observers = self.observers {
            for observer in observers {
                observer.onRemove?()
            }
        }

        self.observers = []
    }
}
