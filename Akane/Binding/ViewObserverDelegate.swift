//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ViewObserverDelegate {
    func bind(observer: ViewObserver, viewModel: ViewModel)
}

public extension ViewObserverDelegate where
    Self : UITableView,
    Self : ComponentTableView,
    Self.DataSourceType : TableItemDataSource,
    Self.DataSourceType.DataType == Self.ViewModelType.CollectionDataType,
    Self.DataSourceType.ItemIdentifier.RawValue == String
{
    func bind(observer: ViewObserver, viewModel: ViewModel) {
        let viewModel = viewModel as! Self.ViewModelType
        let delegate = TableViewDelegate(tableView: self, collectionViewModel: viewModel)

        delegate.becomeDataSource(observer, data: viewModel.collection)
    }
}

public extension ViewObserverDelegate where
    Self : UITableView,
    Self : ComponentTableView,
    Self.DataSourceType : TableSectionDataSource,
    Self.DataSourceType.DataType == Self.ViewModelType.CollectionDataType,
    Self.DataSourceType.ItemIdentifier.RawValue == String,
    Self.ViewModelType : CollectionSectionViewModel,
    Self.DataSourceType.SectionIdentifier.RawValue == String
{
    func bind(observer: ViewObserver, viewModel: ViewModel) {
        let viewModel = viewModel as! Self.ViewModelType
        let delegate = TableViewSectionDelegate(tableView: self, collectionViewModel: viewModel)

        delegate.becomeDataSource(observer, data: viewModel.collection)
    }
}