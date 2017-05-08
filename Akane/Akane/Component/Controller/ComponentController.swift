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
public protocol ComponentController : class, ComponentContainer {
    // MARK: Associated component elements
    
    /// The Controller's ComponentView.
    var componentView: ComponentView? { get }

    /// The Controller's CompnentViewModel.
    var viewModel: ComponentViewModel! { get set }

    // MARK: Child `ComonentController`s
    
    /**
    Adds a child controller.
    
    - parameter childController: The child `ComonentController` to add.
    */
    func addController<C:UIViewController>(_ childController: C) where C:ComponentController

    /**
    Searches through child controllers and returns the matching 
    `ComponentController`.
    
    - parameter component: The `ComponentView` presented by the
    `ComponentController` to be searched after.
    
    - returns: The `ComponentController` whose `ComponentView` equals
    `component`, `nil` otherwise.
    */
    func controllerForComponent<V:UIView>(_ component: V) -> ComponentViewController? where V:ComponentView

    // MARK: Lifecycle
    
    /**
    Should be called every time `viewModel` is setted on Controller.
    */
    func didLoadComponent()
}

extension ComponentController {
    public func makeBindings() {
        guard let viewModel = self.viewModel, let componentView = self.componentView else {
            return
        }

        self.stopBindings()
        componentView.observerCollection = ObservationCollection()

        componentView.componentLifecycle = self
        componentView.bindings(componentView, viewModel: viewModel)
    }

    public func stopBindings() {
        self.componentView?.observerCollection?.removeAllObservers()
    }
}
