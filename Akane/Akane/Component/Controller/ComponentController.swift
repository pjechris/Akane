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
}

/**
ComponentController is a Controller making the link between a `ComponentView`
and its `ComponentViewModel`.
*/
public protocol ComponentController : class, ComponentContainer, HasAssociatedObjects, AnyComponentController {
    associatedtype ViewType: ComponentDisplayable

    // MARK: Associated component elements
    
    /// The Controller's ComponentView.
    var componentView: ViewType? { get }

    /// The Controller's CompnentViewModel.
    var viewModel: ViewType.Parameters! { get set }
    
    /**
     Called every time `viewModel` is setted on Controller.
     You can use it to (re)initialize anything related to ViewModel.
     You can also use it to bind components which are "outside" workflow/hierarchy, like navigation bar.
    */
    func didLoadComponent()
}

extension ComponentController {
    public func setup(viewModel: Any) {
        guard let viewModel = viewModel as? ViewType.Parameters else {
            return
        }

        self.viewModel = viewModel
    }

    public func didLoadComponent() {
    }
}

extension ComponentController {
    public var observer: ViewObserver! {
        get { return self.associatedObjects["observer"] as? ViewObserver }
        set { self.associatedObjects["observer"] = newValue }
    }

    public func renewBindings() {
        guard let viewModel = self.viewModel, let componentView = self.componentView else {
            return
        }

        componentView.bindings(self.observer, params: viewModel)
    }
}

extension ComponentController where Self : UIViewController {
    /// The Controller's ComponentView.
    public var componentView: ViewType? {
        get { return self.view as? ViewType }
    }

    /// The Controller's CompnentViewModel.
    public var viewModel: ViewType.Parameters! {
        get {
            return self.associatedObjects["viewModel"] as? ViewType.Parameters
        }
        set {
            self.associatedObjects["viewModel"] = newValue
            self.didSetViewModel()
        }
    }

    func didSetViewModel() {
        self.observer = ViewObserver(container: self)
        self.viewModel.router = self as? ComponentRouter
        self.didLoadComponent()
        self.renewBindings()
        self.viewModel.mountIfNeeded()
    }
}

extension ComponentController where Self : ComponentDisplayable {
    func bindings(_ observer: ViewObserver, viewModel: ViewType.Parameters) {
        self.viewModel = viewModel
    }
}
