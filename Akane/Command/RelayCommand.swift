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
`RelayCommand` is a concretization of the `Command` protocol providing
 basic actions.

It provides 2 closures:
- `canExecute` a block updating the command availability. Optional
- `action` the block containing the action to execute
*/
public class RelayCommand : Command {
    public private(set) var canExecute : Observable<Bool> = Observable(true)
    var action: ((UIControl?) -> ())! = nil
    var canExecuteUpdater: () -> Bool
    
    // MARK: Initializers
    
    /**
    Instantiates a new `RelayCommand`.
    
    - parameter canExecuteUpdater: A closure returning `true` if the command is 
    available, false otherwise
    - parameter action:            The command logic to execute when `execute` 
    is called
    
    - seeAlso: `init(action:)`
    */
    public init(canExecute canExecuteUpdater: () -> Bool, action: (UIControl?) -> ()) {
        self.canExecuteUpdater = canExecuteUpdater
        self.action = action

        self.updateCanExecute()
    }

    /**
    Creates a command with the given action. The command is considered as always
    executable
    
    - parameter action: The command logic to execute when `execute` is called
    */
    public convenience init(action: (UIControl?) -> ()) {
        self.init(canExecute: { return true }, action: action)
    }
    
    // MARK: Execution

    /// Update the command execute status using the provided initializer block
    public func updateCanExecute() {
        self.canExecute.value = self.canExecuteUpdater()
    }

    /// - see: `Command.execute(_:)`
    public func execute(trigger: UIControl?) {
        if self.canExecute.value {
            self.action(trigger)
        }
    }
}