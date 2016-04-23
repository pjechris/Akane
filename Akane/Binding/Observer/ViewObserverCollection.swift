//
// This file is part of Akane
//
// Created by JC on 08/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
 Contain multiple `Observer` instances which can be disposed at any time
*/
class ViewObserverCollection {
    private typealias ObserverType = (observer: _Observer, onRemove: (Void -> Void)?)

    var count: Int { return self.observers.count }
    private var observers: [ObserverType] = []

    deinit {
        self.removeAllObservers()
    }

    func append(observer: _Observer, onRemove: (Void -> Void)? = nil) {
        self.observers.append((observer: observer, onRemove: onRemove))
    }

    func removeAllObservers() {
        for observer in self.observers {
            observer.onRemove?()
        }

        self.observers = []
    }

    func unobserve() {
        self.removeAllObservers()
    }
}

//extension ViewObserverCollection : ViewObserver {
//
//    func observe<AnyValue>(value: AnyValue) -> AnyObserver<AnyValue> {
//        let observer = AnyObserver(value: value)
//
//        self.append(observer)
//
//        return observer
//    }
//
//    func observe(value: Command) -> CommandObserver {
//        let observer = CommandObserver(command: value)
//
//        self.append(observer)
//
//        return observer
//    }
//
//    func observe<ViewModelType: ComponentViewModel>(value: ViewModelType) -> ViewModelObserver<ViewModelType> {
//        let observer = ViewModelObserver<ViewModelType>(lifecycle: self.lifecycle)
//
//        self.append(observer)
//
//        return observer
//    }
//}