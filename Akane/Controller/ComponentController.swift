//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 ComponentController is a Controller which knows how to deal with a ```ComponentView``` and a ```ViewModel```.
*/
public protocol ComponentController : class {
    /// the Controller component view
    /// While using generics to constraint it would be great, it causes issues with Storyboards and Xibs.
    var componentView: ComponentView! { get }

    /// the Controller view model
    /// While using generics to constraint it would be great, it causes issues with Storyboards and Xibs.
    var viewModel: ViewModel! { get set }

    /// Init with a view which sould implement ```ComponentView``` protocol.
    /// Once again, using generics to would have been great but it causes issues with Storyboards and Xibs :(
    init(view: UIView)

    /// Add a child Component controller
    /// - param childController: the child controller to add
    func addController<C:UIViewController where C:ComponentController>(childController: C)

    /// Search through child controllers and return the matching ```ComponentController```
    /// - Returns the ```ComponentController``` whose ```componentView``` equals ```component, nil otherwise
    func controllerForComponent<V:UIView where V:ComponentView>(component: V) -> ComponentViewController?

    /// Called when both ```viewModel``` and ```componentView``` are loaded
    func didLoad()
}