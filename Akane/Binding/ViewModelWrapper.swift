//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelWrapper<T: Observation where T.Element: AKNViewModelProtocol> {
    let viewModel: T
    let disposeBag: DisposeBag
    unowned let lifecycle: Lifecycle

    init(viewModel: T, lifecycle: Lifecycle, disposeBag: DisposeBag) {
        self.viewModel = viewModel
        self.lifecycle = lifecycle
        self.disposeBag = disposeBag
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T) {
        let controller:ComponentViewController<T>? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

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