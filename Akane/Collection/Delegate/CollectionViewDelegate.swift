//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class CollectionViewDelegate<
    CollectionViewModelType : ComponentCollectionItemsViewModel,
    DataSourceType : DataSourceCollectionViewItems> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate
{
    var templateHolder: [CollectionElementCategory:Template]
    weak var observer: ViewObserver?
    weak var collectionViewModel: CollectionViewModelType!
    unowned var collectionView: UICollectionView
    var dataSource: DataSourceType! {
        didSet { self.collectionView.reloadData() }
    }

    /// init the delegate with a `UITableView` and its view model
    public init(collectionView: UICollectionView, collectionViewModel: CollectionViewModelType) {
        self.collectionView = collectionView
        self.templateHolder = [:]
        self.collectionViewModel = collectionViewModel

        super.init()

        objc_setAssociatedObject(self.collectionView, &TableViewDataSourceAttr, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// make the delegate effective
    public func becomeDataSource(observer: ViewObserver, dataSource: DataSourceType) {
        self.observer = observer
        self.dataSource = dataSource

        // Without casting swift complains about ambiguous delegate
        (self.collectionView as UICollectionView).delegate = self
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
        let template = self.templateHolder.findOrCreate(.Cell(identifier: data.identifier.rawValue)) {
            let template = self.dataSource.collectionViewItemTemplate(data.identifier)

            self.collectionView.register(template, type: .Cell(identifier: data.identifier.rawValue))

            return template
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(data.identifier.rawValue, forIndexPath: indexPath)

        if let item = data.item {
            let viewModel = self.collectionViewModel.createItemViewModel(item as! CollectionViewModelType.ItemType)

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
            let viewModel = self.collectionViewModel.createItemViewModel(item as! CollectionViewModelType.ItemType) as? ComponentItemViewModel {
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
        let viewModel = self.collectionViewModel.createItemViewModel(item as! CollectionViewModelType.ItemType) as! ComponentItemViewModel

        viewModel.select!.execute(nil)
    }

    @objc
    /// - returns the row index path if its viewModel is of type `ComponentItemViewModel` and it defines `unselect`, nil otherwise
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, shouldDeselectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, shouldDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.collectionViewModel.createItemViewModel(item as! CollectionViewModelType.ItemType) as! ComponentItemViewModel

        return (viewModel.unselect != nil) ? indexPath : nil
    }

    @objc
    /// Call the row view model `unselect` `Command`
    /// - seeAlso: `UICollectionViewDelegate.collectionView(_:, didDeselectRowAtIndexPath:)`
    public func collectionView(collectionView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataSource.itemAtIndexPath(indexPath).item
        let viewModel = self.collectionViewModel.createItemViewModel(item as! CollectionViewModelType.ItemType) as! ComponentItemViewModel

        viewModel.unselect!.execute(nil)
    }

}