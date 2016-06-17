//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

/**
Default implementation of `ComponentController`. You need to extend from this 
class rather than from `UIViewController` to make binding binding your component
view and your view model work.
*/
public class ComponentViewController : UIViewController, ComponentController {
    public var viewModel: ComponentViewModel! {
        didSet { self.didSetViewModel() }
    }

    public var componentView: ComponentView? {
        get { return self.isViewLoaded() ? self.view as? ComponentView : nil }
    }

    override public var view: UIView! {
        didSet { self.makeBindings() }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.mount()
    }

    func didSetViewModel() {
        self.viewModel.router = self as? ComponentRouter
        self.didLoadComponent()
        self.makeBindings()
    }

    public func didLoadComponent() {
    }
}

extension ComponentController where Self:UIViewController {

    public func addController<C:UIViewController where C:ComponentController>(childController: C) {
        if (!self.childViewControllers.contains(childController)) {
            self.addChildViewController(childController)
            childController.didMoveToParentViewController(self)
        }
    }

    public func controllerForComponent<V:UIView where V:ComponentView>(component: V) -> ComponentViewController? {
        for childViewController in self.childViewControllers {
            if let controller = childViewController as? ComponentViewController {
                if (controller.view == component) {
                    return controller
                }
            }
        }

        return nil
    }
}