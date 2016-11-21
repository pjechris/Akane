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
 Contain multiple `Observation` instances which can be disposed at any time
*/
class ObservationCollection {
    fileprivate typealias ObserverType = (observer: _Observation, onRemove: ((Void) -> Void)?)

    var count: Int { return self.observers.count }
    fileprivate var observers: [ObserverType] = []

    deinit {
        self.removeAllObservers()
    }

    func append(_ observer: _Observation, onRemove: ((Void) -> Void)? = nil) {
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
