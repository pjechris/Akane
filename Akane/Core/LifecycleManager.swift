//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public extension AKNLifecycleManager {
    public func bindView() {
        let view = self.view() as! AKNViewComponent

        view.componentDelegate = self;
        view.bind?(self.viewModel());

        if let view = view as? ViewComponent {
            let binder = BondBinderView(view: view)

            view.bindings(binder)
        }
    }
}
