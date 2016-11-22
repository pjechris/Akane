//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.

- *Future enhancements:* this protocol will be generic once we will be able to 
use generics with Storyboard/Xib
*/
public protocol ComponentView : class, HasAssociatedObjects {

    /**
     `ComponentViewController` class associated to the `ComponentView`

     - returns: The `ComponentViewController` type.
     The Default implementation returns `ComponentViewController.self`
     */
    static func componentControllerClass() -> ComponentViewController.Type
}

extension ComponentView {

    public static func componentControllerClass() -> ComponentViewController.Type {
        return ComponentViewController.self
    }
}
