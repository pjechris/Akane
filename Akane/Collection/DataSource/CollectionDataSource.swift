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

    func itemAtIndexPath(indexPath: NSIndexPath) -> (item: ItemType?, identifier: ItemIdentifier)

    func collectionViewItemTemplate(identifier: ItemIdentifier) -> Template
}

public protocol DataSourceCollectionViewSections : DataSourceCollectionViewItems {
    typealias SectionType
    typealias SectionIdentifier: RawStringRepresentable

    func sectionItemAtIndex(index: Int) -> (item: SectionType?, identifier: SectionIdentifier)

    func collectionViewSectionTemplate(identifier: SectionIdentifier) -> Template
}