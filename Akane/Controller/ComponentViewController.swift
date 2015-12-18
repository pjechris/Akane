//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

public class ComponentViewController<ViewType: UIView where ViewType: ViewComponent> : UIViewController, ComponentController {
    public var viewModel: AKNViewModelProtocol!
    public var componentView: ViewType! {
        get { return self.view as! ViewType }
    }

//    lazy let lifecycleManager: lifecycleManager = LifecycleManager()

    public required init(view: ViewType) {
        super.init(nibName: nil, bundle: nil)

        self.view = view
        self.viewDidLoad()
    }
}

extension ComponentController where Self:UIViewController {
    public func didLoad() {

    }
    
    public func addController<C:UIViewController where C:ComponentController>(childController: C) {
        if (!self.childViewControllers.contains(childController)) {
            self.addChildViewController(childController)
            childController.didMoveToParentViewController(self)
        }
    }

    public func controllerForComponent<V:UIView, C:ComponentController where V:ViewComponent, C.ViewType == V>(component: V) -> C? {
        for childViewController in self.childViewControllers {
            if let controller = childViewController as? C {
                if (controller.componentView == component) {
                    return controller
                }
            }
        }

        return nil
    }
}