//
// This file is part of Akane
//
// Created by JC on 17/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

extension UITableView {
    func update(cell: UIView) {
        self.beginUpdates()
        cell.layoutIfNeeded()
        self.endUpdates()
    }
}

extension UICollectionView {
    func update(element: CollectionElementCategory, atIndexPath indexPath: NSIndexPath) {
        let invalidationContext = UICollectionViewLayoutInvalidationContext()

        switch (element) {
        case .Cell(_):
            invalidationContext.invalidateItemsAtIndexPaths([indexPath])
        case .Section(_, let kind):
            invalidationContext.invalidateSupplementaryElementsOfKind(kind, atIndexPaths: [indexPath])
        }

        self.collectionViewLayout.invalidateLayoutWithContext(invalidationContext)
    }
}