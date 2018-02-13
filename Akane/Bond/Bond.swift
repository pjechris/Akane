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

    public func observe<Signal: SignalProtocol>(_ observable: Signal) -> AnyObservation<Signal.Element> {
        let observer = AnyObservation<Signal.Element>(value: nil, observer: self)
        
        let disposable : Disposable = observable.observeNext { value in
            observer.put(value)
        }

        self.add(disposable: disposable)

        return observer
    }

    public func observe<Signal: SignalProtocol, AnyAttribute>(_ observable: Signal, attribute: @escaping (Signal.Element) -> AnyAttribute) -> AnyObservation<AnyAttribute> {
        return self.observe(observable.map(attribute))
    }

    public func observe<Signal: SignalProtocol>(_ observable: Signal) -> ViewModelObservation<Signal.Element> where Signal.Element : ComponentViewModel {
        let observer = ViewModelObservation<Signal.Element>(value: nil, container: self.container!, observer: self)

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
        let observation = CommandObservation(command: command, observer: self)

        self.add(disposable: { observation.unbind() })

        return observation
    }
}
