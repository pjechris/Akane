//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class ViewModelObservation<ViewModelType: ComponentViewModel> : Observation {
    public var value: ViewModelType? = nil

    public var next: [((ViewModelType) -> Void)] = []

    unowned let container: ComponentContainer

    public init(value: ViewModelType?, container: ComponentContainer) {
        self.container = container
        self.value = value
    }
}

extension ViewModelObservation {

    public func bind<ViewType: UIView>(to view: ViewType?) where ViewType: ComponentView {
        if let view = view {
            self.bind(to: view)
        }
    }

    public func bind<ViewType: UIView>(to view: ViewType) where ViewType: ComponentView {
        let controller: AnyComponentController? = self.container.component(for: view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.observe { value in
            controller!.setup(viewModel: value)
        }
    }
}
