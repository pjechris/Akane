//
// This file is part of Akane
//
// Created by JC on 19/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 AutoLayout support for `UICollectionView` and `UITableView`
*/
public class CollectionAutoLayout : NSObject, CollectionLayout {
    static let defaultEstimatedHeight: CGFloat = 42

    let estimatedRowHeight: CGFloat
    let estimatedFooterHeight: CGFloat
    let estimaedHeaderHeight: CGFloat

    convenience public init(estimatedHeight: CGFloat) {
        self.init(estimatedRowHeight: estimatedHeight, estimatedFooterHeight: estimatedHeight, estimatedHeaderHeight: estimatedHeight)
    }

    convenience public override init() {
        self.init(estimatedHeight: CollectionAutoLayout.defaultEstimatedHeight)
    }

    public init(estimatedRowHeight: CGFloat, estimatedFooterHeight: CGFloat, estimatedHeaderHeight: CGFloat) {
        self.estimatedRowHeight = estimatedRowHeight
        self.estimatedFooterHeight = estimatedFooterHeight
        self.estimaedHeaderHeight = estimatedHeaderHeight
    }

    public func heightForItem(indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func estimatedHeightForItem(indexPath: NSIndexPath) -> CGFloat {
        return self.estimatedRowHeight
    }

    public func heightForSection(section: Int, sectionKind: String) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func estimatedHeightForSection(section: Int, sectionKind: String) -> CGFloat {
        switch(sectionKind) {
        case "header":
            return self.estimaedHeaderHeight
        case "footer":
            return self.estimatedFooterHeight
        default:
            return 0
        }
    }

    public func didReuseView(reusableView: UIView) {

    }
}