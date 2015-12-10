//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var BinderAttribute = "ViewStyleNameAttribute"

public extension AKNLifecycleManager {
    private var binder: ViewObserverCollection! {
        get { return objc_getAssociatedObject(self, &BinderAttribute) as? ViewObserverCollection }
        set { objc_setAssociatedObject(self, &BinderAttribute, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc
    func attach() {
        if let view = self.view() as? AKNViewComponent {
            view.presenter = self.presenter
        }
    }

    @objc func detach() {
        if let view = self.view() as? AKNViewComponent {
            view.presenter = nil
        }
    }

    @objc
    public func bindView() {
        let view = self.view() as! AKNViewComponent

        view.componentDelegate = self;
        view.bind?(self.viewModel()) // BC <= 0.11

        if let view = view as? ViewComponent {
            self.binder = ViewObserverCollection(view: self.view())

            if let viewModel = self.viewModel() {
                view.bindings(binder, viewModel: viewModel)
            }
        }
    }
}
