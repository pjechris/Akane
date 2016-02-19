//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

extension UICollectionView {
    func register(template: Template, type: CollectionRowType) {
        switch(type) {
        case .Item(let identifier) where template.nib != nil:
            self.registerNib(template.nib, forCellWithReuseIdentifier: identifier)

        case .Item(let identifier):
            self.registerClass(template.templateClass, forCellWithReuseIdentifier: identifier)

        case .Section(let identifier, let kind) where template.nib != nil:
            self.registerNib(template.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)

        case .Section(let identifier, let kind):
            self.registerClass(template.templateClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

}