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
    typealias ItemType
    /// Possible identifier(s) associated with a row item. Use an `enum`
    typealias ItemIdentifier: RawStringRepresentable
    typealias ItemViewModelType : ComponentViewModel

    /// Ask to return the item that correspond to the specified index path
    /// - returns an optional row item with an identifier for the current item and index path
    func itemAtIndexPath(indexPath: NSIndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    /// Ask a `Template` for the row identifier
    /// - parameter identifier: use the identifier to compare and return the suited `Template`
    /// - returns `Template` associated with the given identifier
    func tableViewItemTemplate(identifier: ItemIdentifier) -> Template

    /**
     Creates a new `ItemViewModelType` for the given item

     - parameter item: The item to create a `ComponentViewModel` for

     - returns: A new ViewModel of type `ItemViewModelType`
     */
    func createItemViewModel(item: ItemType?) -> ItemViewModelType?
}

/// Provide data and `Template`s for a `UITableView` with section support
public protocol DataSourceTableViewSections : DataSourceTableViewItems {
    /// Type of the section items.
    /// If you do not intend to associate any data with your section, just set it to `Any`
    typealias SectionType
    /// Possible identifier(s) associated with a section item. Use an `enum`
    typealias SectionIdentifier: RawStringRepresentable
    typealias SectionViewModelType : ComponentViewModel

    /// Ask to return the item associated with the section index
    /// - returns an optional section item with an identifier for the current section
    func sectionItemAtIndex(index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    /// Ask a `Template` for the section identifier
    /// - parameter identifier: use the identifier to compare and return the suited `Template`
    /// - returns optional `Template` associated with the given identifier. Return nil when you do not want to display
    /// a section
    func tableViewSectionTemplate(identifier: SectionIdentifier, kind: String) -> Template

    /**
     Creates a new `SectionViewModelType` for the given section item

     - parameter item: The section item to create a `ComponentViewModel` for

     - returns: A new viewmodel of type `SectionViewModelType`
     */
    func createSectionViewModel(item: SectionType?) -> SectionViewModelType?
}