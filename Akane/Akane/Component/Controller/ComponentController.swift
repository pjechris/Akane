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
public protocol ComponentController : ComponentDisplayable, ComponentContainer {
    associatedtype ViewType: ComponentDisplayable where ViewType.Parameters == Parameters

    // MARK: Associated component elements
    
    /// The Controller's ComponentView.
    var componentView: ViewType? { get }

    /// The Controller's CompnentViewModel.
    var viewModel: ViewType.Parameters! { get }
    
    /**
     Called every time `viewModel` is setted on Controller.
     You can use it to (re)initialize anything related to ViewModel.
     You can also use it to bind components which are "outside" workflow/hierarchy, like navigation bar.
    */
    func didLoadComponent()
}

extension ComponentController {
    public func didLoadComponent() {
    }
}

extension ComponentController {
    /// The Controller's CompnentViewModel.
    public fileprivate(set) var viewModel: ViewType.Parameters! {
        get {
            return self.associatedObjects["viewModel"] as? ViewType.Parameters
        }
        set {
            self.associatedObjects["viewModel"] = newValue
        }
    }

    public func bindings(_ observer: ViewObserver, params viewModel: ViewType.Parameters) {
        self.viewModel = viewModel
        self.didLoadComponent()

        viewModel.mountIfNeeded()

        if let componentView = componentView {
            componentView.bindings(observer, params: viewModel)
        }
    }
}

extension ComponentController where Self : UIViewController {
    /// The Controller's ComponentView.
    public var componentView: ViewType? {
        get { return self.view as? ViewType }
    }
}
