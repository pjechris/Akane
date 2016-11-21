//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 `Converter` allowing to make conversion from `ConvertValueType` to `ValueType`
*/
public protocol ConverterReverse : Converter {
    
    // MARK: Conversion
    
    /**
     Perform the inverse conversion, from `ValueType` to `ConvertValueType`
     
     - parameter value: The value to convert back
     
     - returns: The converted value
     */
    func convertBack(_ value: ConvertValueType) -> ValueType
}
