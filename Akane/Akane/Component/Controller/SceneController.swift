//
//  Scene.swift
//  Akane
//
//  Created by pjechris on 25/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation
import HasAssociatedObjects

/**
 `ComponentController` which can render itself
 Use it on your top controllers to render the whole hierarchy.
 **/
public protocol SceneController : ComponentController {
    func renderScene(_ params: Parameters, context: Context)
}

extension SceneController {
    public fileprivate(set) var observer: ViewObserver! {
        get { return self.associatedObjects["observer"] as? ViewObserver }
        set { self.associatedObjects["observer"] = newValue }
    }

    public func renderScene(_ viewModel: Parameters, context: Context) {
        self.observer = ViewObserver(container: self, context: context)

        viewModel.mountIfNeeded()
        self.bind(self.observer, params: viewModel)
    }
}
