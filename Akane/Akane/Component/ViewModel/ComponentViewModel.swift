//
// This file is part of Akane
//
// Created by JC on 19/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewModelIsMountedAttr = "ViewModelIsMountedAttr"
var ViewModelRouterAttr = "ViewModelRouterAttr"

/**
A ComponentViewModel stores a Component-related business logic. 
As an example, a ComponentViewModel can implement networking logic, 
model instantiations, or simple algorithms.

It is intended to be bound on a `UIView` conforming to `ComponentView`.

Whenever a ComponentViewModel is displayed for the first time, the
`willMount` function is called, in order to perform additional 
configuration.
*/
public protocol ComponentViewModel : class {
    /// Notifies the `ComponentViewModel` when it is going to be mounted. 
    /// Use this method to perform additional operations.
    func willMount()
}

extension ComponentViewModel {
    /// Defines whether the `ComponentViewModel` is mounted or not.
    /// A ComponentViewModel is marked as mounted when displayed the first time.
    public internal(set) var isMounted: Bool {
        get { return (objc_getAssociatedObject(self, &ViewModelIsMountedAttr) as? NSNumber).map { return $0.boolValue } ?? false }
        set { objc_setAssociatedObject(self, &ViewModelIsMountedAttr, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    weak public var router: ComponentRouter? {
        get {
            guard let router = objc_getAssociatedObject(self, &ViewModelRouterAttr) as? AnyWeakValue else {
                return nil
            }

            return router.value as? ComponentRouter
        }
        set { objc_setAssociatedObject(self, &ViewModelRouterAttr, AnyWeakValue(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// The base implementation is a no-op.
    public func willMount() {
    }
}

extension ComponentViewModel {

    func mount() {
        guard !self.isMounted else {
            return
        }

        self.willMount()
        self.isMounted = true

    }
}
