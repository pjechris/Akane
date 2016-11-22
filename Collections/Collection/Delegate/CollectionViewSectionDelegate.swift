//
// This file is part of Akane
//
// Created by JC on 24/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Akane

open class CollectionViewSectionDelegate<DataSourceType : DataSourceCollectionViewSections> : CollectionViewDelegate<DataSourceType>
{
    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }

    @objc
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let data = self.dataSource.sectionItemAtIndex(indexPath.section)
        let template = self.dataSource.collectionViewSectionTemplate(data.identifier, kind: kind)
        let element = CollectionElementCategory.section(identifier: data.identifier.rawValue, kind: kind)

        collectionView.registerIfNeeded(template, type: element)

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: data.identifier.rawValue, for: indexPath)

        if template.needsComponentViewModel {
            if let viewModel = self.dataSource.createSectionViewModel(data.item) {
                self.observer?.observe(viewModel).bindTo(cell, template: template)

                if let updatable = viewModel as? Updatable {
                    updatable.onRender = { [weak collectionView, weak cell] in
                        if let collectionView = collectionView, let _ = cell {
                            collectionView.update(element, atIndexPath: indexPath)
                        }
                    }
                }
            }
        }

        return cell
    }
}
