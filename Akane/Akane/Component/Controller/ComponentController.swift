//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

/**
ComponentController is a Controller making the link between a `ComponentView`
and its `ComponentViewModel`.
*/
public protocol ComponentController : class, ComponentContainer, HasAssociatedObjects {
    associatedtype ViewType: ComponentDisplayable

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
    func setup(viewModel: Any) {
        guard let viewModel = viewModel as? ViewType.ViewModelType else {
            return
        }

        self.viewModel = viewModel
    }

    public func didLoadComponent() {

    }
}

extension ComponentController {
    public var observer: ViewObserver? {
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

extension ComponentController where Self : ComponentDisplayable {
    func bindings(_ observer: ViewObserver, viewModel: ViewType.ViewModelType) {
        self.viewModel = viewModel
    }
}
