//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class TableViewSectionDelegate<DataSourceType : DataSourceTableViewSections> : TableViewDelegate<DataSourceType>
{

    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }

    // MARK: DataSource

    @objc
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.viewForSection(tableView, section: section, sectionKind: "footer")
    }

    @objc
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewForSection(tableView, section: section, sectionKind: "header")
    }

    @objc
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.layout.heightForSection(section, sectionKind: "footer") ?? tableView.sectionFooterHeight
    }

    @objc
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.layout.heightForSection(section, sectionKind: "header") ?? tableView.sectionHeaderHeight
    }

    @objc
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return tableView.layout.estimatedHeightForSection(section, sectionKind: "footer") ?? tableView.estimatedSectionFooterHeight
    }

    @objc
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableView.layout.estimatedHeightForSection(section, sectionKind: "header") ?? tableView.estimatedSectionHeaderHeight
    }

    func viewForSection(tableView: UITableView, section: Int, sectionKind: String) -> UIView? {
        let data = self.dataSource.sectionItemAtIndex(section)
        let sectionType = CollectionElementCategory.Section(identifier: data.identifier.rawValue, kind: sectionKind)
        let template = self.dataSource.tableViewSectionTemplate(data.identifier, kind: sectionKind)

        tableView.registerIfNeeded(template, type: sectionType)

        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(data.identifier.rawValue)!

        if template.needsComponentViewModel {
            if let viewModel = self.dataSource.createSectionViewModel(data.item) {
                self.observer?.observe(viewModel).bindTo(view, template: template)
            }
        }

        return view
    }
}
