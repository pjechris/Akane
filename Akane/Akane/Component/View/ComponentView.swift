//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

public protocol Displayable : class {
    associatedtype Parameters

    /**
     Define the bindings between displayable and its params

     - parameter observer:  The observer to use for defining  and registering
     bindings
     - parameter viewModel: `Parameters` associated to Displayable
     */
    func bindings(_ observer: ViewObserver, params: Parameters)
}

public protocol _AnyComponentDisplayable {
    func _tryBindings(_ observer: ViewObserver, params: Any)
}

@available(*, unavailable, renamed: "ComponentDisplayable")
public typealias ComponentView = ComponentDisplayable

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.
*/
public protocol ComponentDisplayable : Displayable, HasAssociatedObjects, _AnyComponentDisplayable where Parameters : ComponentViewModel {
}

/**
 `ComponentController` class wrapper association
 */
public protocol Wrapped {
    associatedtype Wrapper: UIViewController, ComponentController
}

extension ComponentDisplayable where Self : UIView {
    public func _tryBindings(_ observer: ViewObserver, params: Any) {
        guard let viewModel = params as? Parameters else {
            return
        }

        observer.observe(viewModel).bind(to: self)
    }
}
