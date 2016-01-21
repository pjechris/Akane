//
// This file is part of Akane
//
// Created by JC on 03/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ComponentTableView : ComponentView, ViewObserverDelegate {
    typealias DataSourceType: TableItemDataSource
    typealias ViewModelType: ComponentCollectionItemsViewModel
}