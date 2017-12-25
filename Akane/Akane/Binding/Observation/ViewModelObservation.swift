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

    public func bind<ViewType: UIView & ComponentDisplayable>(to view: ViewType?) where ViewType.Parameters == ViewModelType {
        if let view = view {
            self.bind(to: view)
        }
    }

    public func bind<ViewType: UIView & ComponentDisplayable & Wrapped>(to view: ViewType)
        where ViewType.Parameters == ViewModelType, ViewType.Wrapper.Parameters == ViewModelType {
        guard let observer = self.container.observer?.observer(identifier: view.hashValue) else {
            return
        }

        let controller = self.container.component(for: view)

        self.observe { value in
            observer.dispose()
            value.mountIfNeeded()
            controller.bindings(observer, params: value)
        }
    }

    public func bind<ViewType: UIView & ComponentDisplayable>(to view: ViewType) where ViewType.Parameters == ViewModelType  {
        guard let observer = self.container.observer?.observer(identifier: view.hashValue) else {
            return
        }

        self.observe { value in
            observer.dispose()
            value.mountIfNeeded()
            view.bindings(observer, params: value)
        }
    }
}
