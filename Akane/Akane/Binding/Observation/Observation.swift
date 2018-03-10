//
// This file is part of Akane
//
// Created by JC on 07/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Internal class. Do not use.
public protocol Observation : class {
    associatedtype Element

    var value: Element? { get set }
    var next: [((Element) -> Void)] { get set }
}

extension Observation {
    public func put(_ value: Element) {
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

    func observe(_ block: @escaping ((Element) -> Void)) {
        self.next.append(block)
        self.run()
    }

    public func unobserve() {
        self.next = []
        self.value = nil
    }
}
