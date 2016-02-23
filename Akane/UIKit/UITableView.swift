//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var TableViewLayoutAttr = "TableViewLayoutAttr"

public extension UITableView {
    public var layout: TableViewLayout {
        get {
            if let layout =  objc_getAssociatedObject(self, &TableViewLayoutAttr) as? TableViewLayout {
                return layout
            }

            let layout = TableViewFlowLayout()
            objc_setAssociatedObject(self, &TableViewLayoutAttr, layout, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return layout
        }
        set { objc_setAssociatedObject(self, &TableViewLayoutAttr, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UITableView {
    func register(template: Template, type: CollectionRowType) {
        switch(type) {
        case .Item(let identifier) where template.nib != nil:
            self.registerNib(template.nib, forCellReuseIdentifier: identifier)

        case .Item(let identifier):
            self.registerClass(template.templateClass, forCellReuseIdentifier: identifier)

        case .Section(let identifier, _) where template.nib != nil:
            self.registerNib(template.nib, forHeaderFooterViewReuseIdentifier: identifier)

        case .Section(let identifier, _):
            self.registerClass(template.templateClass, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
}