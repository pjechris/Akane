//
// This file is part of Akane
//
// Created by JC on 03/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Performs navigation through Controllers inside the application.
public protocol ComponentRouter: class {
    /**
     Route a `ComponentViewModel`. `ComponentRouter` should try to display a new UIViewController for this context.

     - parameter context: new context to go to.
     - parameter name: a context name. Not mandatory.
     */
    func route(context: ComponentViewModel, named name: String)

    func route(context: ComponentViewModel)
}

extension ComponentRouter where Self : UIViewController {
    /// Calls to `UIViewController.performSegueWithIdentifier`
    public func route(context: ComponentViewModel, named name: String) {
        if self.shouldPerformSegueWithIdentifier(name, sender: context) {
            self.performSegueWithIdentifier(name, sender: context)
        }
    }

    /// Does nothing
    /// Overrides this method if you want to 'push' or 'present' a `UIViewController` for current context
    public func route(context: ComponentViewModel) {

    }
}