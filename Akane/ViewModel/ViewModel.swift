//
// This file is part of Akane
//
// Created by JC on 19/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewModelIsMountedAttr = "ViewModelIsMountedAttr"

extension AKNViewModelProtocol {
    var isMounted: NSNumber? {
        get { return objc_getAssociatedObject(self, &ViewModelIsMountedAttr) as? NSNumber }
        set { objc_setAssociatedObject(self, &ViewModelIsMountedAttr, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}