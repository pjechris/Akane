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

    public func bind<ViewType: UIView>(to view: ViewType?) where ViewType: ComponentDisplayable {
        if let view = view {
            self.bind(to: view)
        }
    }

    public func bind<ViewType: UIView>(to view: ViewType) where ViewType: ComponentDisplayable {
        let controller: AnyComponentController? = self.container.component(for: view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.observe { value in
            controller!.setup(viewModel: value)
        }
    }

    public func display<V: ComponentDisplayable & ContentAccessible>(_ type: V.Type, in view: V.Content)
        where V.Content: UIView, V.ViewModelType == ViewModelType
    {
        guard let observer = self.container.observer?.observer(identifier: view.hashValue) else {
            return
        }

        let displayer = observer.cachedDisplayer as? V ?? type.init(content: view)

        observer.cachedDisplayer = displayer

        self.observe { value in
            observer.dispose()
            displayer.bindings(observer, viewModel: value)
        }
    }
}
