//
//  DisplayObservation+Bond.swift
//  Akane
//
//  Created by pjechris on 01/02/2018.
//  Copyright © 2018 fr.akane. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
#if AKANE_AS_FRAMEWORK
    import Akane
#endif

extension DisplayObservation {
    public func to(params: Observable<View.Parameters>) {
        let disposable = params.observeNext(with: self.to(params:))

        self.observer.add(disposable: disposable)
    }
}

extension DisplayObservation where View : ComponentDisplayable {
    public func to(params viewModel: Observable<View.Parameters>) {
        let disposable = viewModel.observeNext(with: self.to(params:))

        self.observer.add(disposable: disposable)
    }
}

extension DisplayObservation where View : Wrapped {
    public func to(params viewModel: Observable<View.Parameters>) {
        let disposable = viewModel.observeNext(with: self.to(params:))

        self.observer.add(disposable: disposable)
    }
}
