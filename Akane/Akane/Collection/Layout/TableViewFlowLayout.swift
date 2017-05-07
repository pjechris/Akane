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
open class TableViewFlowLayout : NSObject, TableViewLayout {
    public typealias Height = (estimated: CGFloat?, actual: CGFloat)

    let rowHeight: Height?
    let footerHeight: Height?
    let headerHeight: Height?

    public init(rowHeight: Height? = nil, headerHeight: Height? = nil, footerHeight: Height? = nil) {
        self.rowHeight = rowHeight
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
    }

    open func heightForCell(_ indexPath: IndexPath) -> CGFloat? {
        return self.rowHeight?.actual
    }

    open func estimatedHeightForCell(_ indexPath: IndexPath) -> CGFloat? {
        return self.rowHeight?.estimated
    }

    open func heightForSection(_ section: Int, sectionKind: String) -> CGFloat? {
        switch(sectionKind) {
        case "header":
            return self.headerHeight?.actual
        case "footer":
            return self.footerHeight?.actual
        default:
            return nil
        }
    }

    open func estimatedHeightForSection(_ section: Int, sectionKind: String) -> CGFloat? {
        switch(sectionKind) {
        case "header":
            return self.headerHeight?.estimated
        case "footer":
            return self.footerHeight?.estimated
        default:
            return 0
        }
    }

    open func didReuseView(_ reusableView: UIView) {
        reusableView.layoutIfNeeded()
    }
}
