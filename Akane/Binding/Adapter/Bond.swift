//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

extension Bond.Observable : Akane.Bindable {
    public func advance() -> (Element -> Void) {
        return self.sink(nil)
    }
}

extension ViewObserver {
    func observe<AnyValue>(observable: Observable<AnyValue>) -> AnyObservation<AnyValue> {
        let observer = AnyObservation<AnyValue>()

        let disposable : DisposableType = observable.observe { value in
            observer.value(value)
        }

        self.observerCollection?.append(observer) {
            disposable.dispose()
        }

        return observer
    }

    func observe<AnyValue, AnyAttribute>(observable: Observable<AnyValue>, attribute: AnyValue -> AnyAttribute) -> AnyObservation<AnyAttribute> {
        return self.observe(observable).convert(attribute)
    }

    func observe<ViewModelType: ComponentViewModel>(observable: Observable<ViewModelType>) -> ViewModelObservation<ViewModelType> {
        let observer = ViewModelObservation<ViewModelType>(lifecycle: self.componentLifecycle!)

        let disposable : DisposableType = observable.observe { value in
            observer.value(value)
        }

        self.observerCollection?.append(observer) {
           disposable.dispose()
        }

        return observer
    }
}
