//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

open class TableViewSectionDelegate<DataSourceType : DataSourceTableViewSections> : TableViewDelegate<DataSourceType>
{

    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }

    // MARK: DataSource

    @objc
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.viewForSection(tableView, section: section, sectionKind: "footer")
    }

    @objc
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewForSection(tableView, section: section, sectionKind: "header")
    }

    @objc
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.layout.heightForSection(section, sectionKind: "footer") ?? tableView.sectionFooterHeight
    }

    @objc
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.layout.heightForSection(section, sectionKind: "header") ?? tableView.sectionHeaderHeight
    }

    @objc
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return tableView.layout.estimatedHeightForSection(section, sectionKind: "footer") ?? tableView.estimatedSectionFooterHeight
    }

    @objc
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableView.layout.estimatedHeightForSection(section, sectionKind: "header") ?? tableView.estimatedSectionHeaderHeight
    }

    func viewForSection(_ tableView: UITableView, section: Int, sectionKind: String) -> UIView? {
        let data = self.dataSource.sectionItemAtIndex(section)
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: data.identifier.rawValue)!

        if let viewModel = self.dataSource.createSectionViewModel(data.item),
            let observer = self.observer,
            let componentView = view as? _AnyComponentView {

            componentView._tryBindings(observer, viewModel: viewModel)

            if let updatable = viewModel as? Updatable {
                updatable.onRender = { [weak tableView, weak view] in
                    if let tableView = tableView, let view = view {
                        tableView.update(view)
                    }
                }
            }
        }

        return view
    }
}
