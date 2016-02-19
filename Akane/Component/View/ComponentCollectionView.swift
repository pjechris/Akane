//
// This file is part of Akane
//
// Created by JC on 08/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 To use on `UICollectionView` to make connections between the view, its `ComponentCollectionViewModel` and its `DataSource`
 */
public protocol ComponentCollectionView : ComponentView, ViewObserverDelegate {
    typealias DataSourceType: DataSourceCollectionViewItems
    typealias ViewModelType: ComponentCollectionItemsViewModel
}