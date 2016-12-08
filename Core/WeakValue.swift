//
// This file is part of Akane
//
// Created by JC on 25/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public typealias AnyWeakValue = WeakValue<AnyObject>

/// Stores a weak ref on an AnyObject.
public class WeakValue<ValueType: AnyObject> {
    public weak var value: ValueType?

    public init(_ value: ValueType?) {
        self.value = value
    }
}
