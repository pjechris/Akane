//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var BinderAttribute = "ViewStyleNameAttribute"

protocol Lifecycle : class {
    func presenterForSubview<T:UIView where T:ComponentView>(subview: T, createIfNeeded: Bool) -> ComponentViewController?
}

/**
Handles controller view and view model lifecycles.
*/
class ControllerLifecycle<C:UIViewController where C:ComponentController> : Lifecycle {
    var binder: ViewObserverCollection!
    unowned private let controller: C

    init(controller: C) {
        self.controller = controller
    }

    func bindView() {
        let componentView = self.controller.componentView
        self.binder = ViewObserverCollection(view: self.controller.view, lifecycle: self)

        componentView.bindings(binder, viewModel: self.controller.viewModel)
    }

    func presenterForSubview<T:UIView where T:ComponentView>(subview: T, createIfNeeded: Bool = true) -> ComponentViewController? {
        guard (subview.isDescendantOfView(self.controller.view) || subview.window == nil) else {
            return nil
        }

        if let controller = self.controller.controllerForComponent(subview) {
            return controller
        }

        if (createIfNeeded) {
            let componentClass:ComponentViewController.Type = subview.dynamicType.componentControllerClass()
            let controller = componentClass.init(view: subview)

            self.controller.addController(controller)

            return controller
        }
        
        return nil
    }
}
