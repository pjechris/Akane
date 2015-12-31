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

public class TableDataSource<V: ViewModelDataSource where V.DataSourceType.RowIdentifier.RawValue == String> : NSObject, UITableViewDataSource, UITableViewDelegate {
    public typealias ViewModelDataSourceSourceType = V
    public typealias DataSourceType = ViewModelSourceType.DataSourceType

    let dataSource: DataSourceType
    let templateHolder: TemplateHolder<DataSourceType.RowIdentifier>
    weak var observer: ViewObserverCollection?
    weak var viewModelDataSource: ViewModelDataSourceSourceType?

    public init(dataSource: DataSourceType, viewModelDataSource: ViewModelSourceType, @noescape templates: (holder: TemplateHolder<DataSourceType.RowIdentifier>) -> Void) {
        self.dataSource = dataSource
        self.viewModelSource = viewModelSource
        self.templateHolder = TemplateHolder()

        templates(holder: self.templateHolder)
    }

    internal func becomeDataSource(tableView: UITableView, observer: ViewObserverCollection) {
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