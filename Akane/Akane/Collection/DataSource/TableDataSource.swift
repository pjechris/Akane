//
// This file is part of Akane
//
// Created by JC on 06/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Provide data and `Template`s for a `UITableView`
public protocol DataSourceTableViewItems : DataSource {
    /// Type of the row items returned by the data source for the `UITableView`
    associatedtype ItemType
    /// Possible identifier(s) associated with a row item. Use an `enum`
    associatedtype ItemIdentifier: RawStringRepresentable
    associatedtype ItemViewModelType : ComponentViewModel

    /// Ask to return the item that correspond to the specified index path
    /// - returns an optional row item with an identifier for the current item and index path
    func itemAtIndexPath(_ indexPath: IndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    /**
     Creates a new `ItemViewModelType` for the given item

     - parameter item: The item to create a `ComponentViewModel` for

     - returns: A new ViewModel of type `ItemViewModelType`
     */
    func createItemViewModel(_ item: ItemType?) -> ItemViewModelType?
}

/// Provide data and `Template`s for a `UITableView` with section support
public protocol DataSourceTableViewSections : DataSourceTableViewItems {
    /// Type of the section items.
    /// If you do not intend to associate any data with your section, just set it to `Any`
    associatedtype SectionType
    /// Possible identifier(s) associated with a section item. Use an `enum`
    associatedtype SectionIdentifier: RawStringRepresentable
    associatedtype SectionViewModelType : ComponentViewModel

    /// Ask to return the item associated with the section index
    /// - returns an optional section item with an identifier for the current section
    func sectionItemAtIndex(_ index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    /**
     Creates a new `SectionViewModelType` for the given section item

     - parameter item: The section item to create a `ComponentViewModel` for

     - returns: A new viewmodel of type `SectionViewModelType`
     */
    func createSectionViewModel(_ item: SectionType?) -> SectionViewModelType?
}
