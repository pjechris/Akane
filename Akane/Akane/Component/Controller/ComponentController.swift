//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

public protocol AnyComponentController {
    func setup(viewModel: Any)
    func anyViewModel() -> Any?
}

/**
ComponentController is a Controller making the link between a `ComponentView`
and its `ComponentViewModel`.

Do not use this protocol directly. Refer to `ComponentViewController` instead.
 
This protocol should benefit greatly by the use of generics, but this would
break compatibility with Storyboards and Xibs.
*/
public protocol ComponentController : class, ComponentContainer, AnyComponentController, HasAssociatedObjects {
    associatedtype ViewType: ComponentView

    // MARK: Associated component elements
    
    /// The Controller's ComponentView.
    var componentView: ViewType? { get }

    /// The Controller's CompnentViewModel.
    var viewModel: ViewType.ViewModelType! { get set }
    
    /**
    Should be called every time `viewModel` is setted on Controller.
    */
    func didLoadComponent()
}

extension ComponentController {
    public func setup(viewModel: Any) {
        guard let viewModel = viewModel as? ViewType.ViewModelType else {
            return
        }

        self.viewModel = viewModel
    }

    public func anyViewModel() -> Any? {
        return self.viewModel
    }

    public func didLoadComponent() {

    }
}

extension ComponentController {
    fileprivate var observer: ViewObserver? {
        get { return self.associatedObjects["observer"] as? ViewObserver }
        set { self.associatedObjects["observer"] = newValue }
    }

    public func renewBindings() {
        guard let viewModel = self.viewModel, let componentView = self.componentView else {
            return
        }

        let observer = ViewObserver(container: self)

        componentView.bindings(observer, viewModel: viewModel)
        self.observer = observer
    }
}

extension ComponentController where Self : UIViewController {
    /// The Controller's ComponentView.
    public var componentView: ViewType? {
        get { return self.view as? ViewType }
    }

    /// The Controller's CompnentViewModel.
    public var viewModel: ViewType.ViewModelType! {
        get {
            return self.associatedObjects["viewModel"] as? ViewType.ViewModelType
        }
        set {
            self.associatedObjects["viewModel"] = newValue
            self.didSetViewModel()
        }
    }

    func didSetViewModel() {
        self.viewModel.router = self as? ComponentRouter
        self.didLoadComponent()
        self.renewBindings()
        self.viewModel.mountIfNeeded()
    }
}
