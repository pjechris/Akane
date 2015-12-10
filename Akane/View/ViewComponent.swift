//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ViewComponentPresenterAttr = "ViewComponentPresenterAttr"

public protocol ViewComponent : AKNViewComponent {
    func bindings(observer: ViewObserver, viewModel: AnyObject)
}

extension AKNViewComponent {
    weak var presenter: AKNPresenter? {
        get { return objc_getAssociatedObject(self, &ViewComponentPresenterAttr) as? AKNPresenter }
        set { return objc_setAssociatedObject(self, &ViewComponentPresenterAttr, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}