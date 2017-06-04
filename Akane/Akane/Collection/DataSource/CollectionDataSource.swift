//
// This file is part of Akane
//
// Created by JC on 06/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol DataSourceCollectionViewItems : DataSource {
    associatedtype ItemType
    associatedtype ItemIdentifier: RawStringRepresentable
    associatedtype ItemViewModelType : ComponentViewModel

    func itemAtIndexPath(_ indexPath: IndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    /**
     Creates a new `ItemViewModelType` for the given item

     - parameter item: The item to create a `ComponentViewModel` for

     - returns: A new ViewModel of type `ItemViewModelType`
     */
    func createItemViewModel(_ item: ItemType?) -> ItemViewModelType?
}

public protocol DataSourceCollectionViewSections : DataSourceCollectionViewItems {
    associatedtype SectionType
    associatedtype SectionIdentifier: RawStringRepresentable
    associatedtype SectionViewModelType : ComponentViewModel

    func sectionItemAtIndex(_ index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    /**
     Creates a new `SectionViewModelType` for the given section item

     - parameter item: The section item to create a `ComponentViewModel` for

     - returns: A new viewmodel of type `SectionViewModelType`
     */
    func createSectionViewModel(_ item: SectionType?) -> SectionViewModelType?
}
