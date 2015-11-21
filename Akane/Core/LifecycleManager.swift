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
    private var binder: ViewBinderManager<ViewComponent>! {
        get { return objc_getAssociatedObject(self, &BinderAttribute) as? ViewBinderManager<ViewComponent> }
        set { objc_setAssociatedObject(self, &BinderAttribute, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc
    public func bindView() {
        let view = self.view() as! AKNViewComponent

        view.componentDelegate = self;
        view.bind?(self.viewModel());

        if let view = view as? ViewComponent {
            if self.binder == nil {
                self.binder = ViewBinderManager(view: view)
            }

            binder.bind(self.viewModel())
            view.bindings(binder)
        }
    }
}
