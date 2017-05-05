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

extension Bond : Akane.Bindable {
    public func advance(element: Element) -> Void {
        let tmp = Observable(element)
        tmp.bind(to: self).dispose()
    }
}

extension ViewObserver {
    public func observe<AnyValue>(_ observable: Observable<AnyValue>) -> AnyObservation<AnyValue> {
        let observer = AnyObservation<AnyValue>(value: nil)
        
        let disposable : Disposable = observable.observeNext { value in
            observer.put(value)
        }

        self.observerCollection?.append(observer) {
            disposable.dispose()
        }

        return observer
    }

    public func observe<AnyValue, AnyAttribute>(_ observable: Observable<AnyValue>, attribute: @escaping (AnyValue) -> AnyAttribute) -> AnyObservation<AnyAttribute> {
        return self.observe(observable).convert(attribute)
    }

    public func observe<ViewModelType: ComponentViewModel>(_ observable: Observable<ViewModelType>) -> ViewModelObservation<ViewModelType> {
        let observer = ViewModelObservation<ViewModelType>(value: nil, lifecycle: self.componentLifecycle!)

        let disposable : Disposable = observable.observeNext { value in
            observer.put(value)
        }

        self.observerCollection?.append(observer) {
           disposable.dispose()
        }

        return observer
    }
}
