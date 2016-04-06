//
// This file is part of Akane
//
// Created by JC on 06/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol DataSourceCollectionViewItems : DataSource {
    typealias ItemType
    typealias ItemIdentifier: RawStringRepresentable
    typealias ItemViewModelType : ComponentViewModel

    func itemAtIndexPath(indexPath: NSIndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    func collectionViewItemTemplate(identifier: ItemIdentifier) -> Template

    /**
     Creates a new `ItemViewModelType` for the given item

     - parameter item: The item to create a `ComponentViewModel` for

     - returns: A new ViewModel of type `ItemViewModelType`
     */
    func createItemViewModel(item: ItemType?) -> ItemViewModelType?
}

public protocol DataSourceCollectionViewSections : DataSourceCollectionViewItems {
    typealias SectionType
    typealias SectionIdentifier: RawStringRepresentable
    typealias SectionViewModelType : ComponentViewModel

    func sectionItemAtIndex(index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    func collectionViewSectionTemplate(identifier: SectionIdentifier, kind: String) -> Template

    /**
     Creates a new `SectionViewModelType` for the given section item

     - parameter item: The section item to create a `ComponentViewModel` for

     - returns: A new viewmodel of type `SectionViewModelType`
     */
    func createSectionViewModel(item: SectionType?) -> SectionViewModelType?
}