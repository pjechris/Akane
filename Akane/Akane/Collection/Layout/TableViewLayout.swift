//
// This file is part of Akane
//
// Created by JC on 19/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 Generic protocol to handle collection views (`UICollectionView` and `UITableView`) layouts
*/
public protocol TableViewLayout : NSObjectProtocol {
    func heightForCell(_ indexPath: IndexPath) -> CGFloat?
    func estimatedHeightForCell(_ indexPath: IndexPath) -> CGFloat?

    func heightForSection(_ section: Int, sectionKind: String) -> CGFloat?
    func estimatedHeightForSection(_ section: Int, sectionKind: String) -> CGFloat?

    func didReuseView(_ reusableView: UIView)
}
