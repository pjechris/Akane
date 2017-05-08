//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

var BinderAttribute = "ViewStyleNameAttribute"

    func presenterForSubview<T:UIView>(_ subview: T, createIfNeeded: Bool) -> ComponentViewController? where T:ComponentView
public protocol ComponentContainer : class {
}

/**
Handles controller view and view model lifecycles.
*/
extension ComponentController where Self : UIViewController {

    public func presenterForSubview<T:UIView>(_ subview: T, createIfNeeded: Bool = true) -> ComponentViewController? where T:ComponentView {
        guard (subview.isDescendant(of: self.view) || subview.window == nil) else {
            return nil
        }

        if let controller = self.controllerForComponent(subview) {
            return controller
        }

        if (createIfNeeded) {
            let componentClass:ComponentViewController.Type = type(of: subview).componentControllerClass()
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
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWith: data as Data)
    }
}
