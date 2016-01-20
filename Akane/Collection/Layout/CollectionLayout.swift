//
// This file is part of Akane
//
// Created by JC on 19/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol CollectionLayout : NSObjectProtocol {
    func heightForItem(indexPath: NSIndexPath) -> CGFloat
    func estimatedHeightForItem(indexPath: NSIndexPath) -> CGFloat

    func heightForSection(section: Int, sectionKind: String) -> CGFloat
    func estimatedHeightForSection(section: Int, sectionKind: String) -> CGFloat

    func didReuseView(reusableView: UIView)
}