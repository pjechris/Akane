//
// This file is part of Akane
//
// Created by JC on 17/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

extension UITableView {
    func update(_ cell: UIView) {
        self.beginUpdates()
        cell.layoutIfNeeded()
        self.endUpdates()
    }
}

extension UICollectionView {
    func update(_ element: CollectionElementCategory, atIndexPath indexPath: IndexPath) {
        let invalidationContext = UICollectionViewLayoutInvalidationContext()

        switch (element) {
        case .cell:
            invalidationContext.invalidateItems(at: [indexPath])
        case .supplementaryView(kind: let kind):
            invalidationContext.invalidateSupplementaryElements(ofKind: kind, at: [indexPath])
        }

        self.collectionViewLayout.invalidateLayout(with: invalidationContext)
    }
}
