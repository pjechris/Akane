//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Enable observe a property changes through an "event"
public protocol Observation {
    /// Type of generated event property
    typealias Element

    /// Current value of the property
    var value: Element { get }

    /// Registers observer and returns a disposable that can cancel observing
    /// - parameter observer: the observer to register
    /// - returns: a `Dispose` signal that can be used to stop observing
    func observe(observer: Element -> ()) -> Dispose
}