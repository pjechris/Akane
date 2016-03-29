//
// This file is part of Akane
//
// Created by JC on 19/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewModelIsMountedAttr = "ViewModelIsMountedAttr"

/**
A ComponentViewModel stores a Component-related business logic. 
As an example, a ComponentViewModel can implement networking logic, 
model instantiations, or simple algorithms.

It is intended to be bound on a `UIView` conforming to `ComponentView`.

Whenever a CompnentViewModel is displayed for the first time, the 
`willMount` function is called, in order to perform additional 
configuration.
*/
public protocol ComponentViewModel : class {
    
    // MARK: Properties
    
    /// Defines whether the `ComponentViewModel` is mounted or not. 
    /// A ComponentViewModel is marked as mounted when displayed the first time.
    var isMounted: Bool { get }

    // MARK: Lifecycle
    
    /// Notifies the `ComponentViewModel` when it is going to be mounted. 
    /// Use this method to perform additional operations.
    func willMount()
}

extension ComponentViewModel {
    public internal(set) var isMounted: Bool {
        get { return (objc_getAssociatedObject(self, &ViewModelIsMountedAttr) as? NSNumber).map { return $0.boolValue } ?? false }
        set { objc_setAssociatedObject(self, &ViewModelIsMountedAttr, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// The base implementation is a no-op.
    public func willMount() {
    }

    func mount() {
        guard !self.isMounted else {
            return
        }

        self.willMount()
        self.isMounted = true

    }
}