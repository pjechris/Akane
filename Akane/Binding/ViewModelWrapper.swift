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
    internal let viewModel: T
    internal unowned let superview: UIView

    init(superview: UIView, viewModel: T) {
        self.superview = superview
        self.viewModel = viewModel
    }

    public func bindTo<T:UIView where T:ViewComponent>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:ViewComponent>(view: T) {
        var presenter:AKNPresenter? = view.presenter

        assert(view.window != nil)
        assert(view.isDescendantOfView(self.superview))

        guard (view.window != nil && view.isDescendantOfView(self.superview)) else {
            return
        }

        self.viewModel.observe { [weak self, unowned view] viewModel in

            if (presenter == nil) {
                let presenterClass:AKNPresenter.Type = view.dynamicType.componentPresenterClass!() as! AKNPresenter.Type

                presenter = presenterClass.init(view: view)
                self?.superview.presenter?.addPresenter(presenter!)
            }

            presenter?.setupWithViewModel(viewModel)
        }
    }
}