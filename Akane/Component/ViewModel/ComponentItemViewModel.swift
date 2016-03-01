//
// This file is part of Akane
//
// Created by JC on 21/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
A ComponentItemViewModel is a `ComponentViewModel` representing an item from
a Collection set

It is intended to be bound on a `UICollectionViewCell` or a 
`UITableViewCell`
*/
public protocol ComponentItemViewModel : ComponentViewModel {
    
    // MARK: Commands
    
    /// Executed when the item is selected.
    var select: Command? { get }
    
    /// Executed when the item is unselected.
    var unselect: Command? { get }
}