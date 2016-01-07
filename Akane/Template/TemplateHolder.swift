//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

class TemplateHolder {
    var itemTemplates: [String:Template] = [:]

    func itemTemplate(itemIdentifier: String, @noescape missing getTemplate: () -> Template) -> Template {
        if let template = self.itemTemplates[itemIdentifier] {
            return template
        }

        let template = getTemplate()
        self.itemTemplates[itemIdentifier] = template

        return template
    }
}