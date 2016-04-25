//
// This file is part of Akane
//
// Created by JC on 21/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 *  Makes a Element as selectable.
 */
public protocol Selectable {
    /// To execute when the element is "selected"
    var commandSelect: Command { get }
}