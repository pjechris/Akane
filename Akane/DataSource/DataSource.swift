//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol DataSource {
    typealias RowItemType
    typealias RowIdentifier: RawRepresentable

    func numberOfItemsInSection(section: Int) -> Int
    func dataAtIndexPath(indexPath: NSIndexPath) -> (item: RowItemType?, identifier: RowIdentifier)
}