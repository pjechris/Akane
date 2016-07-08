//
// This file is part of Akane
//
// Created by JC on 07/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

protocol _Observation : class {
    func unobserve()
    /// Run any observations that might have been made
    func run()
}

protocol Observation : _Observation {
    associatedtype Element

    var value: Element? { get set }
    var next: [(Element -> Void)] { get set }
}

extension Observation {
    func put(value: Element) {
        self.value = value
        self.run()
    }

    func run() {
        if let value = self.value {
            for step in self.next {
                step(value)
            }
        }
    }

    func observe<NewElement>(yield: ((AnyObservation<NewElement>, Element) -> Void))  -> AnyObservation<NewElement> {
        let nextObserver = AnyObservation<NewElement>(value: nil)

        self.observe { value in
            yield(nextObserver, value)
        }

        return nextObserver
    }

    func observe(block: (Element -> Void)) {
        self.next.append(block)
        self.run()
    }

    func unobserve() {
        self.next = []
        self.value = nil
    }
}