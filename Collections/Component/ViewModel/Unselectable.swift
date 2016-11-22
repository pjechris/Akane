//
// This file is part of Akane
//
// Created by JC on 25/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 *  Makes a Element as unselectable.
 */
public protocol Unselectable {
    /// To execute when the element is "unselected"
    var commandUnselect: Command! { get }
}