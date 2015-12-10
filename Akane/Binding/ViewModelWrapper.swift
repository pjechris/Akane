//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelWrapper<ViewModel: AKNViewModelProtocol, View: UIView where View: AKNViewComponent> {
    internal let viewModel: Observable<ViewModel>
    internal unowned let superview: View

    init(superview: View, viewModel: Observable<ViewModel>) {
        self.superview = superview
        self.viewModel = viewModel
    }

    public func bindTo<T:UIView where T:ViewComponent>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:ViewComponent>(view: T) {
    }
}