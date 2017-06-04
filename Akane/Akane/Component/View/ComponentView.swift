//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

public protocol _AnyComponentView {
    func _tryBindings(_ observer: ViewObserver, viewModel: Any)
}

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.
*/
public protocol ComponentView : class, Equatable, HasAssociatedObjects, _AnyComponentView {
    associatedtype ViewModelType: ComponentViewModel

    /**
    Define the bindings between the fields (IBOutlet) and the ComponentViewModel
    
    - parameter observer:  The observer to use for defining  and registering 
    bindings
    - parameter viewModel: The `ComponentViewModel` associated to the `UIView`
    */
    func bindings(_ observer: ViewObserver, viewModel: ViewModelType)


    /**
     `ComponentViewController` class associated to the `ComponentView`

     - returns: The `ComponentViewController` type.
     The Default implementation returns `ComponentViewController.self`
     */
    static func componentControllerClass() -> AnyComponentController.Type
}

extension ComponentView {

    public static func componentControllerClass() -> AnyComponentController.Type {
        return DefaultViewController<Self>.self
    }
}

extension ComponentView where Self : UIView {
    public func _tryBindings(_ observer: ViewObserver, viewModel: Any) {
        guard let viewModel = viewModel as? ViewModelType else {
            return
        }

        observer.observe(viewModel).bind(to: self)
    }
}
