//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 Make conversion from ```ValueType``` to ```ConvertValueType```
*/
public protocol Converter {
    typealias ValueType
    typealias ConvertValueType

    init()

    /// do the conversion
    /// - param value: the value to convert
    /// - returns the value converted
    func convert(value: ValueType) -> ConvertValueType
}
