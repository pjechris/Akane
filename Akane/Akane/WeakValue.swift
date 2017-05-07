//
// This file is part of Akane
//
// Created by JC on 25/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

typealias AnyWeakValue = WeakValue<AnyObject>

/// Stores a weak ref on an AnyObject.
class WeakValue<ValueType: AnyObject> {
    weak var value: ValueType?

    init(_ value: ValueType?) {
        self.value = value
    }
}