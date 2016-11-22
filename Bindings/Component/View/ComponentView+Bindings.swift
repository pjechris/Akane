//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Akane

public protocol BindableComponentView : ComponentView, ViewObserver {
    /**
     Define the bindings between the fields (IBOutlet) and the ComponentViewModel
     
     - parameter observer:  The observer to use for defining  and registering
     bindings
     - parameter viewModel: The `ComponentViewModel` associated to the `UIView`
     */
    func bindings(_ observer: ViewObserver, viewModel: AnyObject)
}
