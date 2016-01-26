//
// This file is part of Akane
//
// Created by JC on 19/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewModelIsMountedAttr = "ViewModelIsMountedAttr"

/// Store a Component related business logic (network, models, algorithm, ...).
///
/// Intended to be binded on a `UIView` conforming to `ComponentView`.
public protocol ComponentViewModel : class {
    /// whether the `ComponentViewModel` is mounted or not. Marked as mounted when displayed the first time
    var isMounted: Bool { get }

    /// notify the `ComponentViewModel` is going to be mounted. Use this method to make additional operations
    func willMount()
}

public extension ComponentViewModel {
    internal(set) var isMounted: Bool {
        get { return (objc_getAssociatedObject(self, &ViewModelIsMountedAttr) as? NSNumber).map { return $0.boolValue } ?? false }
        set { objc_setAssociatedObject(self, &ViewModelIsMountedAttr, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// does nothing
    func willMount() {

    }
}