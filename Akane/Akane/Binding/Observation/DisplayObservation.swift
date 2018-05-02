//
//  DisplayObservation.swift
//  Akane
//
//  Created by pjechris on 07/01/2018.
//  Copyright © 2018 fr.akane. All rights reserved.
//

import Foundation

public class DisplayObservation<View: Displayable & Hashable> {
    public let view: View
    public var value: View.Parameters? = nil
    public var next: [((View.Parameters) -> Void)] = []

    private unowned let container: ComponentContainer
    public let observer: ViewObserver

    init(view: View, container: ComponentContainer, observer: ViewObserver) {
        self.view = view
        self.container = container
        self.observer = observer
    }
}

extension DisplayObservation {
    public func to(params: View.Parameters) {
        let observer = self.observer.observer(identifier: view.hashValue)

        observer.dispose()
        view.bind(observer, params: params)
    }
}

extension DisplayObservation where View : ComponentDisplayable {
    public func to(params viewModel: View.ViewModel) {
        let observer = self.observer.observer(identifier: view.hashValue)

        observer.dispose()
        viewModel.mountIfNeeded()
        view.bind(observer, params: viewModel)
    }

    /// NOTE: This is alpha API, it might not work properly. Use it with caution.
    public func to<T: Injectable & Paramaterized>(params: T.Parameters) where T == View.Parameters {
        // FIXME context is "leaked"
        var viewModel: T

        if self.view.params != nil {
            viewModel = self.view.params
            viewModel.params = params
        }
        else {
            guard let providedViewModel = self.observer.context.provide(T.self, parameters: params) else {
                return
            }

            viewModel = providedViewModel
        }
        
        self.to(params: viewModel)
    }
}

extension DisplayObservation where View : Wrapped {
    public func to(params viewModel: View.ViewModel) {
        let controller = self.container.component(for: self.view)
        let observer = self.observer.observer(identifier: self.view.hashValue, container: controller)

        observer.dispose()
        viewModel.mountIfNeeded()
        controller.bind(observer, params: viewModel)
    }
}

