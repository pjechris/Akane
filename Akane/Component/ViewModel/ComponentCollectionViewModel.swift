//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
A ComponentCollectionViewModel is a `ComponentViewModel` which ties to a
Collection. It is intended to be bound to a `ComponentTableView` or a 
`ComponentCollectionView`.

This protocol is not meant to be used directly. Please refer to
`ComponentCollectionItemsViewModel` or `ComponentCollectionSectionsViewModel`
instead.
*/
public protocol ComponentCollectionViewModel : ComponentViewModel {
    typealias DataType

    var data: DataType { get }
}

/// The `ComponentCollectionViewModel` representing a Collection of items view model
public protocol ComponentCollectionItemsViewModel : ComponentCollectionViewModel {
    typealias ItemType
    typealias ItemViewModelType : ComponentViewModel

    /**
    Creates a new `ItemViewModelType` for the given item
    
    - parameter item: The item to create a `ComponentViewModel` for
    
    - returns: A new ViewModel of type `ItemViewModelType`
    */
    func createItemViewModel(item: ItemType) -> ItemViewModelType
}

/// The `ComponentCollectionItemsViewModel` representing a Collection set of items view model which *may* have sections
public protocol ComponentCollectionSectionsViewModel : ComponentCollectionItemsViewModel {
    typealias SectionType
    typealias SectionViewModelType : ComponentViewModel
    
    /**
    Creates a new `SectionViewModelType` for the given section item
    
    - parameter item: The section item to create a `ComponentViewModel` for
    
    - returns: A new viewmodel of type `SectionViewModelType`
    */
    func createSectionViewModel(item: SectionType) -> SectionViewModelType
}