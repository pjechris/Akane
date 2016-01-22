//
// This file is part of Akane
//
// Created by JC on 06/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol DataSourceTableViewItems : DataSource {
    typealias ItemType
    typealias ItemIdentifier: RawRepresentable

    func itemAtIndexPath(indexPath: NSIndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    func tableViewItemTemplate(identifier: ItemIdentifier) -> Template
}

public protocol DataSourceTableViewSections : DataSourceTableViewItems {
    typealias SectionType
    typealias SectionIdentifier: RawRepresentable

    func sectionItemAtIndex(index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    func tableViewSectionTemplate(identifier: SectionIdentifier) -> Template?
}