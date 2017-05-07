//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond
#if AKANE_AS_FRAMEWORK
    import Akane
#endif

/**
A Command is just an action you can execute. It also provides information about 
whether or not this command should be made available to user
*/
public protocol BondCommand : Command {
    /// Returns `true` if the command is enabled.
    var canExecute: Observable<Bool> { get }

    var isExecuting: Observable<Bool> { get }
}
