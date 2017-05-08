//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var BinderAttribute = "ViewStyleNameAttribute"

public protocol ComponentContainer : class {
    func component<View: ComponentView>(for: View) -> AnyComponentController?

    func component<View: ComponentView>(for: View, createIfNeeded: Bool) -> AnyComponentController

    func add<ControllerType: ComponentController>(childView: ControllerType.ViewType, controlledBy childController: ControllerType)
}

extension ComponentContainer where Self : UIViewController, Self : ComponentController {
    public func component<View: ComponentView>(for view: View, createIfNeeded: Bool) -> AnyComponentController {
        guard let controller = self.component(for: view) else {
            let controller = DefaultViewController(view: view)

            self.add(childView: view, controlledBy: controller)

            return controller
        }

        return controller
    }

    public func component<View: ComponentView>(for view: View) -> AnyComponentController? {
        for controller in self.childViewControllers {
            if let controllerView = controller.view as? View, controllerView == view {
                return controller as? AnyComponentController
            }
        }

        return nil
    }

    public func add<ControllerType: ComponentController>(childView view: ControllerType.ViewType, controlledBy childComponent: ControllerType) {
        guard let view = view as? UIView, let childController = childComponent as? UIViewController else {
            return
        }

        childController.replace(view: view)
        if (!self.childViewControllers.contains(childController)) {
            self.addChildViewController(childController)
            childController.didMove(toParentViewController: self)
        }
    }
}


// https://medium.com/@mxcl/uiviewcontroller-initializers-in-swift-b4b624448290
extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWith: data as Data)
    }
}
