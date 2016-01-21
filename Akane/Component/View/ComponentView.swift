//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var ComponentViewPresenterAttr = "ComponentViewPresenterAttr"

/**
 ComponentView is used on UIView to reflect that UIView represent/has relation with a business ```ViewModel```

 - Note
    This protocol will be generic once we can use generics with Storyboard/Xib
*/
public protocol ComponentView : class {
    /// define the bindings between the field fields (IBOutlet) and the viewModel
    /// - param observer: observer to use to define/register bindings
    /// - param viewModel: component viewModel from which data come
    func bindings(observer: ViewObserver, viewModel: AnyObject)
}

public extension ComponentView where Self: UIView {
    /// ```Controller``` class associated with ```ComponentView```
    /// - returns a ```ComponentViewController``` type. Default implementation returns ```ComponentViewController.self```
    public static func componentControllerClass() -> ComponentViewController.Type {
        return ComponentViewController.self
    }
}