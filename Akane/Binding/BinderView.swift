//
// This file is part of Akane
//
// Created by JC on 01/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 BinderView is a specialized Binder for views
**/
public protocol BinderView : Binder {
    typealias ViewElement: AKNViewComponent

    var viewModel: AnyObject { get }

    init(view: ViewElement)
}