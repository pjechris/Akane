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
    let observer: ViewObserver

    public init(value: ViewModelType?, container: ComponentContainer, observer: ViewObserver) {
        self.container = container
        self.value = value
        self.observer = observer
    }
}

extension ViewModelObservation {

    public func bind<ViewType: Hashable & ComponentDisplayable>(to view: ViewType?) where ViewType.Parameters == ViewModelType {
        if let view = view {
            self.bind(to: view)
        }
    }

    public func bind<ViewType: Hashable & ComponentDisplayable & Wrapped>(to view: ViewType)
        where ViewType.Parameters == ViewModelType, ViewType.Wrapper.Parameters == ViewModelType {
            let binding = DisplayObservation(view: view, container: self.container, observer: self.observer)

            if let value = self.value {
                binding.to(params: value)
            }
    }

    public func bind<ViewType: Hashable & ComponentDisplayable>(to view: ViewType) where ViewType.Parameters == ViewModelType  {
        let binding = DisplayObservation(view: view, container: self.container, observer: self.observer)

        if let value = self.value {
            binding.to(params: value)
        }
    }
}
