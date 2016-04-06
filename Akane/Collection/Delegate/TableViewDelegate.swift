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

/// Adapter class, making the link between `UITableViewDataSource`, `UITableViewDelegate` and `DataSource`
public class TableViewDelegate<DataSourceType : DataSourceTableViewItems> : NSObject, UITableViewDataSource, UITableViewDelegate
{
    public private(set) weak var observer: ViewObserver?
    public private(set) var dataSource: DataSourceType

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
    public func becomeDataSourceAndDelegate(tableView: UITableView) {
        objc_setAssociatedObject(tableView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: DataSource

    @objc
    /// - see: `UITableViewDataSource.numberOfSectionsInTableView(_:)`
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }

    @objc
    /// - see: `UITableViewDataSource.tableView(_:, numberOfRowsInSection:)`
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

    @objc
    /// - see: `DataSourceTableViewItems.itemAtIndexPath(_:)`
    /// - see: `DataSourceTableViewItems.tableViewItemTemplate(_:)`
    /// - seeAlso: `UITableViewDataSource.tableView(_:, cellForRowAtIndexPath:)`
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.dataSource.itemAtIndexPath(indexPath)
        let template = self.dataSource.tableViewItemTemplate(data.identifier)

        tableView.registerIfNeeded(template, type: .Cell(identifier: data.identifier.rawValue))

        let cell = tableView.dequeueReusableCellWithIdentifier(data.identifier.rawValue, forIndexPath: indexPath)

        if let viewModel = self.dataSource.createItemViewModel(data.item) {
            self.observer?.observe(viewModel).bindTo(cell, template: template)
        }

        return cell
    }

    // MARK: Layout

    @objc
    /// - see: `CollectionLayout.estimatedHeightForItem(_:)`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, estimatedHeightForRowAtIndexPath:)`
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.layout.estimatedHeightForCell(indexPath) ?? tableView.estimatedRowHeight
    }

    @objc
    /// - see: `CollectionLayout.heightForItem(_:)`
    /// - see: `UITableViewDelegate.tableView(_:, heightForRowAtIndexPath:)`
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.layout.heightForCell(indexPath) ?? tableView.rowHeight
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `select`, nil otherwise
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, willSelectRowAtIndexPath:)`
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let item = self.dataSource.itemAtIndexPath(indexPath).item,
            let viewModel = self.dataSource.createItemViewModel(item) as? ComponentItemViewModel {
            return (viewModel.select != nil) ? indexPath : nil
        }

        return nil
    }

    // MARK: Selection

    @objc
    /// Call the row view model `select` `Command`
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, didSelectRowAtIndexPath:)`
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        viewModel.select!.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UITableViewDelegate.tableView(_:, willDeselectRowAtIndexPath:)`
    public func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        return (viewModel.unselect != nil) ? indexPath : nil
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UITableViewDelegate.tableView(_:, didDeselectRowAtIndexPath:)`
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        viewModel.unselect!.execute(nil)
    }
}

