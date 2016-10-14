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
    var viewModels: [NSIndexPath:ComponentViewModel] = [:]

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
    public func becomeDataSourceAndDelegate(collectionView: UICollectionView, reload: Bool = true) {
        objc_setAssociatedObject(collectionView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        collectionView.delegate = self
        collectionView.dataSource = self

        if reload {
            self.viewModels.removeAll()
            collectionView.reloadData()
        }
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
        let element = CollectionElementCategory.Cell(identifier: data.identifier.rawValue)

        collectionView.registerIfNeeded(template, type: element)

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(data.identifier.rawValue, forIndexPath: indexPath)

        if let viewModel = self.dataSource.createItemViewModel(data.item) {
            self.observer?.observe(viewModel).bindTo(cell, template: template)

            if var updatable = viewModel as? Updatable {
                updatable.onRender = { [weak collectionView] in
                    if let collectionView = collectionView {
                        collectionView.update(element, atIndexPath: indexPath)
                    }
                }
            }

            self.viewModels[indexPath] = viewModel
        }
        
        return cell
    }

    // MARK: Selection

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `select`, nil otherwise
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldSelectItemAtIndexPath:)`
    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let _ = self.viewModels[indexPath] as? Selectable else {
            return false
        }

        return true
    }

    @objc
    /// Call the row view model `select` `Command`
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didSelectItemAtIndexPath:)`
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = self.viewModels[indexPath] as? Selectable else {
            return
        }

        viewModel.commandSelect.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldDeselectItemAtIndexPath:)`
    public func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let _ = self.viewModels[indexPath] as? Unselectable else {
            return false
        }

        return true
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didDeselectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = self.viewModels[indexPath] as? Unselectable else {
            return
        }

        viewModel.commandUnselect.execute(nil)
    }

}