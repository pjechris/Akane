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
    public func to(_ params: View.Parameters) {
        view.bindings(observer, params: params)
    }
}

extension DisplayObservation where View : ComponentDisplayable {
    public func to(_ viewModel: View.Parameters) {
        let observer = self.observer.observer(identifier: view.hashValue)

        observer.dispose()
        viewModel.mountIfNeeded()
        view.bindings(observer, params: viewModel)
    }
}

extension DisplayObservation where View : ComponentDisplayable & Wrapped {
    public func to<ViewModel>(_ viewModel: ViewModel) where ViewModel == View.Parameters, ViewModel == View.Wrapper.Parameters {
        let observer = self.observer.observer(identifier: self.view.hashValue)
        let controller = self.container.component(for: self.view)

        observer.dispose()
        viewModel.mountIfNeeded()
        controller.bindings(observer, params: viewModel)
    }
}

