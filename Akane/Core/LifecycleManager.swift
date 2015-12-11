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
    func presenterForSubview<T:UIView where T:AKNViewComponent>(subview: T, createIfNeeded: Bool) -> AKNPresenter?
}

extension AKNLifecycleManager : Lifecycle {
    private var binder: ViewObserverCollection! {
        get { return objc_getAssociatedObject(self, &BinderAttribute) as? ViewObserverCollection }
        set { objc_setAssociatedObject(self, &BinderAttribute, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc
    public func attach() {
        self.view().presenter = self.presenter
    }

    @objc
    public func detach() {
        self.view().presenter = nil
    }

    @objc
    public func bindView() {
        let view = self.view() as! AKNViewComponent

        view.componentDelegate = self;
        view.bind?(self.viewModel()) // BC <= 0.11

        if let view = view as? ViewComponent {
            self.binder = ViewObserverCollection(view: self.view(), lifecycle: self)

            if let viewModel = self.viewModel() {
                view.bindings(binder, viewModel: viewModel)
            }
        }
    }

    func presenterForSubview<T:UIView where T:AKNViewComponent>(subview: T, createIfNeeded: Bool = true) -> AKNPresenter? {
        guard (subview.isDescendantOfView(self.view())) else {
            return nil
        }

        if let presenter = self.presenter?.childPresenterForSubview(subview) {
            return presenter
        }

        if (createIfNeeded) {
            let presenterClass:AKNPresenter.Type = subview.dynamicType.componentPresenterClass!() as! AKNPresenter.Type
            let presenter = presenterClass.init(view: subview)!

            self.presenter?.addChildPresenter(presenter)

            return presenter
        }

        return nil
    }
}
