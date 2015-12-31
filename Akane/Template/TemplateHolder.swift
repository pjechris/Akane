//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class TemplateHolder<RowIdentifier: RawRepresentable where RowIdentifier.RawValue == String> {
    var rowTemplateGenerator: ((RowIdentifier -> Template))!
    var rowTemplates: [RowIdentifier.RawValue:Template] = [:]

    public func registerRow(template: (RowIdentifier -> Template)) {
        self.rowTemplateGenerator = template
    }

    func registerRowIfNeeded(table: UITableView, identifier rowIdentifier: RowIdentifier) {
        if self.rowTemplates[rowIdentifier.rawValue] == nil {
            let template = self.rowTemplateGenerator(rowIdentifier)

            template.register(table, identifier: rowIdentifier.rawValue)
            self.rowTemplates[rowIdentifier.rawValue] = template
        }
    }

    func rowTemplate(rowIdentifier: RowIdentifier) -> Template? {
        return self.rowTemplates[rowIdentifier.rawValue]
    }
}