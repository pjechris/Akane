//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

extension UICollectionView {
    func registerIfNeeded(_ template: Template, type: CollectionElementCategory) {
        if self.registeredTemplates[type] == nil {
            self.register(template, type: type)
        }
    }

    func register(_ template: Template, type: CollectionElementCategory) {
        switch(type, template.source) {
        case (.cell(let identifier), .nib(let nib)):
            self.register(nib, forCellWithReuseIdentifier: identifier)
        case (.cell(let identifier), .file()):
            self.register(template.templateClass, forCellWithReuseIdentifier: identifier)

        case (.section(let identifier, let kind), .nib(let nib)):
            self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        case (.section(let identifier, let kind), .file()):
            self.register(template.templateClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)

        default:
            break
        }
    }
}

extension UICollectionView : HasAssociatedObjects {
    struct Keys {
        static let RegisteredTemplates = "Akane.RegisteredTemplates"
    }

    var registeredTemplates: [CollectionElementCategory:Template]! {
        get {
            guard let templates = self.associatedObjects[Keys.RegisteredTemplates] as? [CollectionElementCategory:Template] else {
                let templates: [CollectionElementCategory:Template] = [:]

                self.registeredTemplates = templates
                return templates
            }

            return templates
        }
        set {
            self.associatedObjects[Keys.RegisteredTemplates] = newValue
        }
    }
}
