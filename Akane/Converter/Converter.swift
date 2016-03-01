//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
Converts a value from `ValueType` to `ConvertValueType`
*/
public protocol Converter {
    typealias ValueType
    typealias ConvertValueType

    // MARK: Initizalizer
    
    /**
    Obtains a new `Converter`
    */
    init()

    // MARK: Conversion
    
    /**
    Performs the conversion from a `ValueType` to a `ConvertValueType`.
    
    - parameter value: The value to convert
    
    - returns: The converted value
    */
    func convert(value: ValueType) -> ConvertValueType
}
