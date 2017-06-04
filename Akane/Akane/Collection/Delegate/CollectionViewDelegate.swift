//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

open class CollectionViewDelegate<DataSourceType : DataSourceCollectionViewItems> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate
{
    open fileprivate(set) weak var observer: ViewObserver?
    open fileprivate(set) var dataSource: DataSourceType
    var viewModels: [IndexPath:ComponentViewModel] = [:]

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
    open func becomeDataSourceAndDelegate(_ collectionView: UICollectionView, reload: Bool = true) {
        objc_setAssociatedObject(collectionView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        collectionView.delegate = self
        collectionView.dataSource = self

        if reload {
            self.viewModels.removeAll()
            collectionView.reloadData()
        }
    }

    // MARK: DataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.numberOfSections()
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInSection(section)
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.dataSource.itemAtIndexPath(indexPath)
        let element = CollectionElementCategory.cell(identifier: data.identifier.rawValue)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.identifier.rawValue, for: indexPath)

        if let viewModel = self.dataSource.createItemViewModel(data.item),
            let observer = self.observer,
            let componentCell = cell as? _AnyComponentView {

            componentCell._tryBindings(observer, viewModel: viewModel)

            if let updatable = viewModel as? Updatable {
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
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let _ = self.viewModels[indexPath] as? Selectable else {
            return false
        }

        return true
    }

    @objc
    /// Call the row view model `select` `Command`
    /// - see: `ComponentItemViewModel.select()`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didSelectItemAtIndexPath:)`
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModels[indexPath] as? Selectable else {
            return
        }

        viewModel.commandSelect.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldDeselectItemAtIndexPath:)`
    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let _ = self.viewModels[indexPath] as? Unselectable else {
            return false
        }

        return true
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didDeselectRowAtIndexPath:)`
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModels[indexPath] as? Unselectable else {
            return
        }
        
        viewModel.commandUnselect.execute(nil)
    }
}
