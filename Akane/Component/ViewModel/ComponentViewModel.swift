//
// This file is part of Akane
//
// Created by JC on 19/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewModelIsMountedAttr = "ViewModelIsMountedAttr"

public protocol ComponentViewModel : class {
    var isMounted: Bool { get }

    func willMount()
}

public extension ComponentViewModel {
    internal(set) var isMounted: Bool {
        get { return (objc_getAssociatedObject(self, &ViewModelIsMountedAttr) as? NSNumber).map { return $0.boolValue } ?? false }
        set { objc_setAssociatedObject(self, &ViewModelIsMountedAttr, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func willMount() {

    }
}