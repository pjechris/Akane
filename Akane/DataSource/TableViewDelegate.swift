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

public class TableViewDelegate<TableViewType : UITableView where
    TableViewType : ComponentTableView,
    TableViewType.DataSourceType.DataType == TableViewType.ViewModelType.CollectionDataType,
    TableViewType.DataSourceType.ItemIdentifier.RawValue == String> : NSObject, UITableViewDataSource, UITableViewDelegate {

    public typealias CollectionViewModelType = TableViewType.ViewModelType
    public typealias DataSourceType = TableViewType.DataSourceType

    let templateHolder: TemplateHolder
    var dataSource: DataSourceType! {
        didSet { self.tableView.reloadData() }
    }
    weak var observer: ViewObserverCollection?
    weak var collectionViewModel: CollectionViewModelType!
    unowned var tableView: TableViewType

    init(tableView: TableViewType, collectionViewModel: CollectionViewModelType) {
        self.tableView = tableView
        self.templateHolder = TemplateHolder()
        self.collectionViewModel = collectionViewModel

        super.init()

        // Without casting swift complains about ambiguous delegate
        (self.tableView as UITableView).delegate = self
        tableView.dataSource = self

        objc_setAssociatedObject(self.tableView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func becomeDataSource(observer: ViewObserverCollection, data: DataSourceType.DataType) {
        self.observer = observer
        self.dataSource = DataSourceType.init(data: data)
    }

    @objc
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }

    @objc
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.dataSource.itemAtIndexPath(indexPath)
        let template = self.templateHolder.itemTemplate(data.identifier.rawValue) {
            let template = self.dataSource.tableViewItemTemplate(data.identifier)
            template.register(self.tableView, identifier: data.identifier.rawValue)

            return template
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(data.identifier.rawValue, forIndexPath: indexPath)

        if let item = data.item {
            let viewModel = self.collectionViewModel.viewModelforItem(item as! CollectionViewModelType.ItemType)

            self.observer?.observe(viewModel).bindTo(cell, template: template)
        }

        return cell
    }

    //    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //    }
}