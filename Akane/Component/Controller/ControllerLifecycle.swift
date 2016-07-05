//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var BinderAttribute = "ViewStyleNameAttribute"

public protocol Lifecycle : class {
    func presenterForSubview<T:UIView where T:ComponentView>(subview: T, createIfNeeded: Bool) -> ComponentViewController?
}

/**
Handles controller view and view model lifecycles.
*/
extension ComponentController where Self : UIViewController {

    public func presenterForSubview<T:UIView where T:ComponentView>(subview: T, createIfNeeded: Bool = true) -> ComponentViewController? {
        guard (subview.isDescendantOfView(self.view) || subview.window == nil) else {
            return nil
        }

        if let controller = self.controllerForComponent(subview) {
            return controller
        }

        if (createIfNeeded) {
            let componentClass:ComponentViewController.Type = subview.dynamicType.componentControllerClass()
            let controller = componentClass.init(coder: NSCoder.empty())!

            controller.view = subview
            controller.viewDidLoad()

            self.addController(controller)

            return controller
        }
        
        return nil
    }
}

// https://medium.com/@mxcl/uiviewcontroller-initializers-in-swift-b4b624448290
extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWithData: data)
    }
}