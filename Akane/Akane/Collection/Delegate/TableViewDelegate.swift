//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

var TableViewDataSourceAttr = "TableViewDataSourceAttr"

/// Adapter class, making the link between `UITableViewDataSource`, `UITableViewDelegate` and `DataSource`
open class TableViewDelegate<DataSourceType : DataSourceTableViewItems> : NSObject, UITableViewDataSource, UITableViewDelegate
{
    open fileprivate(set) weak var observer: ViewObserver?
    open fileprivate(set) var dataSource: DataSourceType
    var viewModels: [IndexPath:ComponentViewModel] = [:]

    /**
     - parameter observer:   the observer which will be used to register observations on cells
     - parameter dataSource: the dataSource used to provide data to the tableView
     */
    public init(observer: ViewObserver, dataSource: DataSourceType) {
        self.observer = observer
        self.dataSource = dataSource
        
        super.init()
    }

    /**
     Makes the class both delegate and dataSource of tableView.

     - parameter tableView: a UITableView on which you want to be delegate and dataSource
     */
    open func becomeDataSourceAndDelegate(_ tableView: UITableView, reload: Bool = true) {
        objc_setAssociatedObject(tableView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        tableView.delegate = self
        tableView.dataSource = self

        if reload {
            self.viewModels.removeAll()
            tableView.reloadData()
        }
    }

    // MARK: DataSource

    @objc
    /// - see: `UITableViewDataSource.numberOfSectionsInTableView(_:)`
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }

    @objc
    /// - see: `UITableViewDataSource.tableView(_:, numberOfRowsInSection:)`
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

    @objc
    /// - see: `DataSourceTableViewItems.itemAtIndexPath(_:)`
    /// - see: `DataSourceTableViewItems.tableViewItemTemplate(_:)`
    /// - seeAlso: `UITableViewDataSource.tableView(_:, cellForRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dataSource.itemAtIndexPath(indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: data.identifier.rawValue, for: indexPath)

        if let viewModel = self.dataSource.createItemViewModel(data.item),
            let observer = self.observer,
            let componentCell = cell as? _AnyComponentView {
            
            componentCell._tryBindings(observer, viewModel: viewModel)

            if let updatable = viewModel as? Updatable {
                updatable.onRender = { [weak tableView, weak cell] in
                    if let tableView = tableView, let cell = cell {
                        tableView.update(cell)
                    }
                }
            }

            self.viewModels[indexPath] = viewModel
        }

        return cell
    }

    // MARK: Layout

    @objc
    /// - see: `CollectionLayout.estimatedHeightForItem(_:)`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, estimatedHeightForRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.layout.estimatedHeightForCell(indexPath) ?? tableView.estimatedRowHeight
    }

    @objc
    /// - see: `CollectionLayout.heightForItem(_:)`
    /// - see: `UITableViewDelegate.tableView(_:, heightForRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.layout.heightForCell(indexPath) ?? tableView.rowHeight
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `select`, nil otherwise
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, willSelectRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let _ = self.dataSource.itemAtIndexPath(indexPath).item,
            let _ = self.viewModels[indexPath] as? Selectable {
            return indexPath
        }

        return nil
    }

    // MARK: Selection

    @objc
    /// Call the row view model `select` `Command`
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, didSelectRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.viewModels[indexPath] as! Selectable

        viewModel.commandSelect.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UITableViewDelegate.tableView(_:, willDeselectRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        _ = self.dataSource.itemAtIndexPath(indexPath).item
        let _ = self.viewModels[indexPath] as! Unselectable

        return indexPath
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, didDeselectRowAtIndexPath:)`
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        _ = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.viewModels[indexPath] as! Unselectable

        viewModel.commandUnselect.execute(nil)
    }
}

