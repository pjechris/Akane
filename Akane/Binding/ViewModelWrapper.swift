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
    unowned let lifecycle: Lifecycle

    init(viewModel: T, lifecycle: Lifecycle) {
        self.viewModel = viewModel
        self.lifecycle = lifecycle
    }

    public func bindTo<T:UIView where T:AKNViewComponent>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:AKNViewComponent>(view: T) {
        let presenter:AKNPresenter? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

        guard (presenter != nil) else {
            return
        }

        self.viewModel.observe { viewModel in
            presenter!.setupWithViewModel(viewModel)
        }
    }
}