//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelWrapper<T: Observation where T.Element: ComponentViewModel> {
    public typealias ObservationType = T
    public typealias ViewModelType = T.Element

    let viewModel: ObservationType
    private let disposeBag: DisposeBag
    unowned let lifecycle: Lifecycle

    init(viewModel: ObservationType, lifecycle: Lifecycle) {
        self.viewModel = viewModel
        self.lifecycle = lifecycle
        self.disposeBag = CompositeDisposable()
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T) {
        self.bind(view)
    }

    func bindTo(cell: UIView, template: Template) {
        template.bind(cell, wrapper: self)
    }

    func bind<T:UIView where T:ComponentView>(view: T) {
        let controller:ComponentViewController? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.disposeBag.addDisposable(
            self.viewModel.observe { viewModel in
                controller!.viewModel = viewModel
            }
        )
    }
}

extension ViewModelWrapper : Dispose {
    public func dispose() {
        self.disposeBag.dispose()
    }
}