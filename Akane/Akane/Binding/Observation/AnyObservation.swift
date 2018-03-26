//
// This file is part of Akane
//
// Created by JC on 04/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

/**
 Provides a minimalistic API tailored to bind a `Element` with a view field.
 */
open class AnyObservation<Element> : Observation {
    public var value: Element?
    public var next: [((Element) -> Void)] = []

    weak var observer: ViewObserver?

    public init(value: Element?, observer: ViewObserver? = nil) {
        self.value = value
        self.observer = observer
    }

    deinit {
        self.unobserve()
    }
}

extension AnyObservation {
    /**
     Updates `Bindable` with current `Element` value.

     - parameter bindable: The bindable item. Should be a view attribute, such as
     the text of a label.
     */
    open func bind<T: Bindable>(to bindable: T) where T.Element == Element {
        self.observe { value in
            bindable.advance(element: value)
        }
    }

    /**
     Updates `Bindable` with current optional `Element` value.

     - parameter bindable: The optional bindable item. Passing `nil` produces
     a no-op.
     */
    open func bind<T: Bindable>(to bindable: T) where T.Element == Optional<Element> {
        self.observe { value in
            bindable.advance(element: value)
        }
    }

    public func bind<V: Displayable & Hashable>(to view: V) where Element == V.Parameters {
        guard let observer = self.observer, let container = observer.container else {
            return
        }

        let binding = DisplayObservation.init(view: view, container: container, observer: observer)

        self.observe {
            binding.to(params: $0)
        }
    }
}
