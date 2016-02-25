//
// This file is part of Akane
//
// Created by JC on 19/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 AutoLayout support for `UITableView`
*/
public class TableViewFlowLayout : NSObject, TableViewLayout {
    public typealias Height = (estimated: CGFloat?, actual: CGFloat)

    let rowHeight: Height?
    let footerHeight: Height?
    let headerHeight: Height?

    public init(rowHeight: Height? = nil, headerHeight: Height? = nil, footerHeight: Height? = nil) {
        self.rowHeight = rowHeight
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
    }

    public func heightForCell(indexPath: NSIndexPath) -> CGFloat? {
        return self.rowHeight?.actual
    }

    public func estimatedHeightForCell(indexPath: NSIndexPath) -> CGFloat? {
        return self.rowHeight?.estimated
    }

    public func heightForSection(section: Int, sectionKind: String) -> CGFloat? {
        switch(sectionKind) {
        case "header":
            return self.headerHeight?.actual
        case "footer":
            return self.footerHeight?.actual
        default:
            return nil
        }
    }

    public func estimatedHeightForSection(section: Int, sectionKind: String) -> CGFloat? {
        switch(sectionKind) {
        case "header":
            return self.headerHeight?.estimated
        case "footer":
            return self.footerHeight?.estimated
        default:
            return 0
        }
    }

    public func didReuseView(reusableView: UIView) {
        reusableView.layoutIfNeeded()
    }
}