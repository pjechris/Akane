//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit
import Bond

var TableViewDataSourceAttr = "TableViewDataSourceAttr"

public class TableViewDelegate<V: ViewModelDataSource where V.DataSourceType.RowIdentifier.RawValue == String> : NSObject, UITableViewDataSource, UITableViewDelegate {
    public typealias ViewModelDataSourceType = V
    public typealias DataSourceType = ViewModelDataSourceType.DataSourceType

    let dataSource: DataSourceType
    let templateHolder: TemplateHolder<DataSourceType.RowIdentifier>
    weak var observer: ViewObserverCollection?
    weak var viewModelDataSource: ViewModelDataSourceType?

    init(dataSource viewModelDataSource: ViewModelDataSourceType, templates: (holder: TemplateHolder<V.DataSourceType.RowIdentifier>) -> Void) {
        self.viewModelDataSource = viewModelDataSource
        self.dataSource = viewModelDataSource.dataSource
        self.templateHolder = TemplateHolder()

        templates(holder: self.templateHolder)
    }

    func becomeDataSource(tableView: UITableView, observer: ViewObserverCollection) {
        self.observer = observer
        objc_setAssociatedObject(tableView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
    }

    @objc
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

//    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let item = self.dataSource.itemAtIndexPath(indexPath)
//        let viewModel: ViewModel
//        let template = self.templateObserver.viewModelTemplate(viewModel) // except deque is not the same
//
//    }

//    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//    }

    @objc
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.dataSource.dataAtIndexPath(indexPath)

        self.templateHolder.registerRowIfNeeded(tableView, identifier: data.identifier)

        let cell = tableView.dequeueReusableCellWithIdentifier(data.identifier.rawValue, forIndexPath: indexPath)
        let template = self.templateHolder.rowTemplate(data.identifier)!

        if let item = data.item, let viewModel = self.viewModelDataSource?.viewModel(forItem: item) {
            self.observer?.observe(viewModel).bindTo(cell, template: template)
        }

        return cell
    }

    //    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //    }
}