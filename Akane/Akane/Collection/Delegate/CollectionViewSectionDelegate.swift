//
// This file is part of Akane
//
// Created by JC on 24/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

@available(*, unavailable, renamed: "CollectionViewAdapter")
open class CollectionViewSectionDelegate<DataSourceType : DataSource> : CollectionViewAdapter<DataSourceType>
{
    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }

    @objc
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.dataSource.section(at: indexPath.section)

        let element = CollectionElementCategory.section(identifier: section.reuseIdentifier, kind: kind)

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: section.reuseIdentifier, for: indexPath)

        if let viewModel = self.dataSource.viewModel(for: section),
            let observer = self.observer,
            let componentCell = cell as? _AnyComponentView {

            componentCell._tryBindings(observer, viewModel: viewModel)

            if let updatable = viewModel as? Updatable {
                updatable.onRender = { [weak collectionView, weak cell] in
                    if let collectionView = collectionView, let _ = cell {
                        collectionView.update(element, atIndexPath: indexPath)
                    }
                }
            }
        }
        
        return cell
    }


}
