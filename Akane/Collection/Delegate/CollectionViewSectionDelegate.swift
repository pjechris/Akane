//
// This file is part of Akane
//
// Created by JC on 24/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class CollectionViewSectionDelegate<DataSourceType : DataSourceCollectionViewSections> : CollectionViewDelegate<DataSourceType>
{
    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }

    @objc
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let data = self.dataSource.sectionItemAtIndex(indexPath.section)
        let template = self.dataSource.collectionViewSectionTemplate(data.identifier, kind: kind)

        collectionView.registerIfNeeded(template, type: .Section(identifier: data.identifier.rawValue, kind: kind))

        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: data.identifier.rawValue, forIndexPath: indexPath)

        if template.needsComponentViewModel {
            if let viewModel = self.dataSource.createSectionViewModel(data.item) {
                self.observer?.observe(viewModel).bindTo(cell, template: template)
            }
        }

        return cell
    }
}
