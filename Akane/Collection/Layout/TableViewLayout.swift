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
    func heightForCell(indexPath: NSIndexPath) -> CGFloat?
    func estimatedHeightForCell(indexPath: NSIndexPath) -> CGFloat?

    func heightForSection(section: Int, sectionKind: String) -> CGFloat?
    func estimatedHeightForSection(section: Int, sectionKind: String) -> CGFloat?

    func didReuseView(reusableView: UIView)
}