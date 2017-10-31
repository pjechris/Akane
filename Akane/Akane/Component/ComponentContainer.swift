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
    var observer: ViewObserver? { get }

    func component<View: ComponentDisplayable>(for: View) -> AnyComponentController?

    func component<View: ComponentDisplayable>(for: View, createIfNeeded: Bool) -> AnyComponentController?

    func add<View: ComponentDisplayable>(childView view: View, controlledBy childComponent: AnyComponentController)
}

extension ComponentContainer where Self : UIViewController, Self : ComponentController {
    public func component<View: ComponentDisplayable>(for view: View, createIfNeeded: Bool) -> AnyComponentController? {
        if let controller = self.component(for: view) {
            return controller
        }

        guard createIfNeeded else {
            return nil
        }

        let classType = type(of: view).componentControllerClass() as! UIViewController.Type
        let controller = classType.init(coder: NSCoder.empty()) as! AnyComponentController

        self.add(childView: view, controlledBy: controller)

        return controller
    }

    public func component<View: ComponentDisplayable>(for view: View) -> AnyComponentController? {
        for controller in self.childViewControllers {
            if let controllerView = controller.view as? View, controllerView === view {
                return controller as? AnyComponentController
            }
        }

        return nil
    }

    public func add<View: ComponentDisplayable>(childView view: View, controlledBy childComponent: AnyComponentController) {
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
