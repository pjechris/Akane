//
// This file is part of Akane
//
// Created by JC on 07/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

protocol _Observer : class {
    func unobserve()
    func runNext()
}

protocol Observer : _Observer {
    typealias Element

    var value: Element? { get set }
    var next: [(Element -> Void)] { get set }
}

extension Observer {
    func value(value: Element) {
        self.value = value
    }

    func runNext() {
        if let value = self.value {
            for step in self.next {
                step(value)
            }
        }
    }

    func observeNext<NewElement>(yield: ((AnyObserver<NewElement>, Element) -> Void))  -> AnyObserver<NewElement> {
        let nextObserver = AnyObserver<NewElement>()

        self.next.append { value in
            yield(nextObserver, value)
        }

        return nextObserver
    }

    func next(block: (Element -> Void)) {
        self.next.append(block)
    }

    func unobserve() {
        self.next = []
        self.value = nil
    }
}