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
    var observer: ViewObserver! { get }

    func component<View: ComponentDisplayable & Wrapped>(for view: View) -> View.Wrapper
}

extension ComponentContainer where Self : UIViewController, Self : ComponentController {
    public func component<View: ComponentDisplayable & Wrapped>(for view: View) -> View.Wrapper {
        if let controller = self.controller(for: view) as? View.Wrapper {
            return controller
        }

        let controller = View.Wrapper.init(coder: NSCoder.empty())!

        self.add(childView: view, controlledBy: controller)

        return controller
    }

    public func controller<View: ComponentDisplayable>(for view: View) -> UIViewController? {
        for controller in self.childViewControllers {
            if controller.view === view {
                return controller
            }
        }

        return nil
    }

    func add<View: ComponentDisplayable>(childView view: View, controlledBy childController: UIViewController) {
        guard let view = view as? UIView else {
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
