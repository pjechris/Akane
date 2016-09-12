//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
A Command is just an action you can execute. It also provides information about 
whether or not this command should be made available to user
*/
public protocol Command {
    /// Returns `true` if the command is enabled.
    var canExecute: Observable<Bool> { get }

    var isExecuting: Observable<Bool> { get }

    /**
    Runs the command action only if `canExecute` is true
    
    - parameter trigger: The `UIControl` which triggered the command. 
    Might be `nil` when triggered programmatically.
    */
    func execute(trigger: UIControl?)
}