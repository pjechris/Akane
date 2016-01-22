//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ComponentCollectionViewModel : ComponentViewModel {
    typealias CollectionDataType

    var collection: CollectionDataType { get }
}

public protocol ComponentCollectionItemsViewModel : ComponentCollectionViewModel {
    typealias ItemType
    typealias ItemViewModelType : ComponentViewModel

    func createItemViewModel(item: ItemType) -> ItemViewModelType
}

public protocol ComponentCollectionSectionsViewModel : ComponentCollectionItemsViewModel {
    typealias SectionType
    typealias SectionViewModelType : ComponentViewModel

    func createSectionViewModel(item: SectionType) -> SectionViewModelType
}