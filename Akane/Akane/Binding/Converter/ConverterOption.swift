//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 `Converter` requiring some options to work correctly
*/
public protocol ConverterOption {
    
    /// Option type. Should be a dedicated struct
    associatedtype ConvertOptionType

    // MARK: Initializer
    
    /**
    Creates the converter with some options. For a given instance, options never change after initialization
    
    - parameter options: The converter options
    */
    init(options: ConvertOptionType)
}