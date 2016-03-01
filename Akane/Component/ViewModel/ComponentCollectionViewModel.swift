//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// a `ComponentViewModel` representing a Collection. Using this base protocol does not make lot of sense: use
/// `ComponentCollectionItemsViewModel` or `ComponentCollectionSectionsViewModel`
///
/// Intended to be binded on a `ComponentTableView` or a `ComponentCollectionView`
public protocol ComponentCollectionViewModel : ComponentViewModel {
    typealias DataType

    var data: DataType! { get }
}

/// a `ComponentCollectionViewModel` representing a Collection set of items view model
public protocol ComponentCollectionItemsViewModel : ComponentCollectionViewModel {
    typealias ItemType
    typealias ItemViewModelType : ComponentViewModel

    /// create a new `ItemViewModelType` for the given item
    /// - parameter item: the item to create a `ComponentViewModel` for
    /// - returns a new viewmodel of type `ItemViewModelType`
    func createItemViewModel(item: ItemType) -> ItemViewModelType
}

/// a `ComponentCollectionItemsViewModel` representing a Collection set of items view model which *may* have sections
public protocol ComponentCollectionSectionsViewModel : ComponentCollectionItemsViewModel {
    typealias SectionType
    typealias SectionViewModelType : ComponentViewModel

    /// create a new `SectionViewModelType` for the given section item
    /// - parameter item: the section item to create a `ComponentViewModel` for
    /// - returns a new viewmodel of type `SectionViewModelType`
    func createSectionViewModel(item: SectionType?) -> SectionViewModelType
}