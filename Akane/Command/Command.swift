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
 A Command is just an action you can execute. It also provides information about whether or not this command
 should be made available to user
*/
public protocol Command {
    /// is this command enabled
    var canExecute: Observable<Bool> { get }

    /// run the command action
    /// - param trigger: the UIControl which triggered the command. Might be nil if triggered by code
    func execute(trigger: UIControl?)
}