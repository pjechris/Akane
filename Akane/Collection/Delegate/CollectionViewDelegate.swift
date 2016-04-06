//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class CollectionViewDelegate<DataSourceType : DataSourceCollectionViewItems> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate
{
    public private(set) weak var observer: ViewObserver?
    public private(set) var dataSource: DataSourceType

    /**
     - parameter observer:   the observer which will be used to register observations on cells
     - parameter dataSource: the dataSource used to provide data to the collectionView
     */
    public init(observer: ViewObserver, dataSource: DataSourceType) {
        self.observer = observer
        self.dataSource = dataSource

        super.init()
    }

    /**
     Makes the class both delegate and dataSource of collectionView

     - parameter collectionView: a UICollectionView on which you want to be delegate and dataSource
     */
    public func becomeDataSourceAndDelegate(collectionView: UICollectionView) {
        objc_setAssociatedObject(collectionView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: DataSource

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.dataSource.numberOfSections()
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let data = self.dataSource.itemAtIndexPath(indexPath)
        let template = self.dataSource.collectionViewItemTemplate(data.identifier)

        collectionView.registerIfNeeded(template, type: .Cell(identifier: data.identifier.rawValue))

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(data.identifier.rawValue, forIndexPath: indexPath)

        if let viewModel = self.dataSource.createItemViewModel(data.item) {
            self.observer?.observe(viewModel).bindTo(cell, template: template)
        }
        
        return cell
    }

    // MARK: Selection

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `select`, nil otherwise
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldSelectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, shouldSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let item = self.dataSource.itemAtIndexPath(indexPath).item,
            let viewModel = self.dataSource.createItemViewModel(item) as? ComponentItemViewModel {
                return (viewModel.select != nil) ? indexPath : nil
        }

        return nil
    }

    @objc
    /// Call the row view model `select` `Command`
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didSelectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        viewModel.select!.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldDeselectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, shouldDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        return (viewModel.unselect != nil) ? indexPath : nil
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didDeselectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.dataSource.createItemViewModel(item) as! ComponentItemViewModel

        viewModel.unselect!.execute(nil)
    }

}