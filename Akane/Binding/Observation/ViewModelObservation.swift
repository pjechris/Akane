//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelObservation<ViewModelType: ComponentViewModel> : Observation {
    var value: ViewModelType? = nil

    var next: [(ViewModelType -> Void)] = []

    unowned let lifecycle: Lifecycle

    init(value: ViewModelType?, lifecycle: Lifecycle) {
        self.lifecycle = lifecycle
        self.value = value
    }
}

extension ViewModelObservation {

    public func bindTo<ViewType: UIView where ViewType: ComponentView>(view: ViewType?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<ViewType: UIView where ViewType: ComponentView>(view: ViewType) {
        let controller: ComponentViewController? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.observe { value in
            controller!.viewModel = value
        }
    }

    func bindTo(cell: UIView, template: Template) {
        template.bind(cell, wrapper: self)
    }
}