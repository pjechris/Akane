//
// This file is part of Akane
//
// Created by JC on 03/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
To use on `UITableView` to make connections between the view, its `ComponentCollectionViewModel` and its `DataSource`
*/
public protocol ComponentTableView : ComponentView, ViewObserverDelegate {
    typealias DataSourceType: DataSourceTableViewItems
    typealias ViewModelType: ComponentCollectionItemsViewModel
}