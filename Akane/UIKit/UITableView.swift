//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

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