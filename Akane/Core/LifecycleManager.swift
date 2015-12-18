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
    func presenterForSubview<T:UIView where T:ViewComponent>(subview: T, createIfNeeded: Bool) -> ComponentViewController<T>?
}

class LifecycleManager<C: ComponentController> : Lifecycle {
    private var binder: ViewObserverCollection!
    unowned private let controller: C

    init(controller: C) {
        self.controller = controller
    }

    @objc
    func bindView() {
        let view = self.controller.componentView
        self.binder = ViewObserverCollection(view: view, lifecycle: self)

        view.bindings(binder, viewModel: self.controller.viewModel)
    }

    func presenterForSubview<T:UIView where T:ViewComponent>(subview: T, createIfNeeded: Bool = true) -> ComponentViewController<T>? {
        let view = self.controller.componentView

        guard (subview.isDescendantOfView(view)) else {
            return nil
        }

        if let controller = self.controller.controllerForComponent(subview) {
            return controller
        }

        if (createIfNeeded) {
            let componentClass:ComponentViewController<T>.Type = subview.dynamicType.componentControllerClass()
            let controller = componentClass.init(view: subview)

            self.controller.addController(controller)

            return controller
        }
        
        return nil
    }
}
