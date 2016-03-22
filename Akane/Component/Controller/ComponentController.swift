//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
ComponentController is a Controller making the link between a `ComponentView`
and its `ComponentViewModel`.

Do not use this protocol directly. Refer to `ComponentViewController` instead.
 
This protocol should benefit greatly by the use of generics, but this would
break compatibility with Storyboards and Xibs.
*/
public protocol ComponentController : class {
    
    // MARK: Associated component elements
    
    /// The Controller's ComponentView.
    var componentView: ComponentView! { get }

    /// The Controller's CompnentViewModel.
    var viewModel: ComponentViewModel! { get set }

    // MARK: Initializers
    
    /// Inits with a view which sould implement `ComponentView` protocol.
    init(view: UIView)

    // MARK: Child `ComonentController`s
    
    /**
    Adds a child controller.
    
    - parameter childController: The child `ComonentController` to add.
    */
    func addController<C:UIViewController where C:ComponentController>(childController: C)

    /**
    Searches through child controllers and returns the matching 
    `ComponentController`.
    
    - parameter component: The `ComponentView` presented by the
    `ComponentController` to be searched after.
    
    - returns: The `ComponentController` whose `ComponentView` equals
    `component`, `nil` otherwise.
    */
    func controllerForComponent<V:UIView where V:ComponentView>(component: V) -> ComponentViewController?

    // MARK: Lifecycle
    
    /**
    Should be called every time `viewModel` is setted on Controller.
    */
    func didLoadComponent()
}