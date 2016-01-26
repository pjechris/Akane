//
// This file is part of Akane
//
// Created by JC on 21/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// a `ComponentViewModel` representing an item from a Collection set
///
/// Intended to be binded on a `UICollectionViewCell` or a `UITableViewCell`
public protocol ComponentItemViewModel : ComponentViewModel {
    /// executed when the item is selected
    var select: Command? { get }
    /// executed when the item is unselected
    var unselect: Command? { get }
}