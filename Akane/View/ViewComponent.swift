//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

protocol ViewComponent : AKNViewComponent {
    func bindings<T: BinderView>(binder: T)
}