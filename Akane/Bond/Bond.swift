//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import ReactiveKit
import Bond
#if AKANE_AS_FRAMEWORK
import Akane
#endif

extension Bond : Akane.Bindable {
    public func advance(element: Element) -> Void {
        let tmp = Observable(element)
        tmp.bind(to: self).dispose()
    }
}

extension ViewObserver {
    func add(disposable: Disposable) {
        self.add(disposable: { disposable.dispose() })
    }

    public func observe<AnyValue>(_ observable: Observable<AnyValue>) -> AnyObservation<AnyValue> {
        let observer = AnyObservation<AnyValue>(value: nil)
        
        let disposable : Disposable = observable.observeNext { value in
            observer.put(value)
        }

        self.add(disposable: disposable)

        return observer
    }

    public func observe<AnyValue, AnyAttribute>(_ observable: Observable<AnyValue>, attribute: @escaping (AnyValue) -> AnyAttribute) -> AnyObservation<AnyAttribute> {
        return self.observe(observable).convert(attribute)
    }

    public func observe<ViewModelType: ComponentViewModel>(_ observable: Observable<ViewModelType>) -> ViewModelObservation<ViewModelType> {
        let observer = ViewModelObservation<ViewModelType>(value: nil, container: self.container!)

        let disposable : Disposable = observable.observeNext { value in
            observer.put(value)
        }

        self.add(disposable: disposable)

        return observer
    }

    /**
     Observes a `Command`.

     - parameter command: The `Command` to be observed.

     - returns: A `CommandObservation`.
     */
    public func observe(_ command: BondCommand) -> CommandObservation {
        return CommandObservation(command: command, observer: self)
    }
}
