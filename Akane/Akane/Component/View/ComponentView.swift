//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

public protocol Displayable {
    associatedtype Props

    func bindings(_ observer: ViewObserver, props: Props)
}

public protocol _AnyComponentDisplayable {
    func _tryBindings(_ observer: ViewObserver, viewModel: Any)
}

@available(*, unavailable, renamed: "ComponentDisplayable")
public typealias ComponentView = ComponentDisplayable

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.
*/
public protocol ComponentDisplayable : class, HasAssociatedObjects, _AnyComponentDisplayable {
    associatedtype ViewModelType: ComponentViewModel

    /**
    Define the bindings between the fields (IBOutlet) and the ComponentViewModel
    
    - parameter observer:  The observer to use for defining  and registering 
    bindings
    - parameter viewModel: The `ComponentViewModel` associated to the `UIView`
    */
    func bindings(_ observer: ViewObserver, viewModel: ViewModelType)
}

/**
 `ComponentController` class wrapper association
 */
public protocol Wrapped {
    associatedtype Wrapper: UIViewController, ComponentController
}

extension ComponentDisplayable where Self : UIView {
    public func _tryBindings(_ observer: ViewObserver, viewModel: Any) {
        guard let viewModel = viewModel as? ViewModelType else {
            return
        }

        observer.observe(viewModel).bind(to: self)
    }
}
