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

    func registerIfNeeded(_ template: Template, type: CollectionElementCategory) {
        if self.registeredTemplates[type] == nil {
            self.register(template, type: type)
        }
    }

    func register(_ template: Template, type: CollectionElementCategory) {
        switch(type, template.source) {
        case (.cell(let identifier), .nib(let nib)):
            self.register(nib, forCellReuseIdentifier: identifier)
        case (.cell(let identifier), .file()):
            self.register(template.templateClass, forCellReuseIdentifier: identifier)

        case (.section(let identifier, _), .nib(let nib)):
            self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        case (.section(let identifier, _), .file()):
            self.register(template.templateClass, forHeaderFooterViewReuseIdentifier: identifier)

        default:
            break
        }

        self.registeredTemplates[type] = template
    }
}

extension UITableView : HasAssociatedObjects {
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
