//
// This file is part of Akane
//
// Created by JC on 17/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

var UpdatableOnRenderAttr = "UpdatableOnRenderAttr"

public protocol Updatable : class, HasAssociatedObjects {
    func setNeedsUpdate()
}

extension Updatable {
    var onRender: ((Void) -> Void)? {
        get { return self.associatedObjects[UpdatableOnRenderAttr] as? ((Void) -> Void) }
        set { self.associatedObjects[UpdatableOnRenderAttr] = onRender }
    }

    func setNeedsUpdate() {
        self.onRender?()
    }
}
