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
 Default implementation of ```Command``` protocol
 
 Provide the developer with 2 blocks :
 - ```canExecute``` a block updating the command availability. Optional
 - ```action``` the block containing the action to execute
*/
public class RelayCommand : Command {
    public private(set) var canExecute : Observable<Bool> = Observable(true)
    private let action: (UIControl?) -> ()
    private let canExecuteUpdater: () -> Bool

    /// @param canExecute a block returning true if command is available, false otherwise
    /// @param action the command logic to execute when ```execute``` is called
    /// @seeAlso init(action:)
    public init(canExecute canExecuteUpdater: () -> Bool, action: (UIControl?) -> ()) {
        self.canExecuteUpdater = canExecuteUpdater
        self.action = action
    }

    /// Create a command with the given action. The command is considered as always executable
    /// @param action the command logic to execute when ```execute``` is called
    public convenience init(action: (UIControl?) -> ()) {
        self.init(canExecute: { return true }, action: action)
    }

    /// Update the command execute status using the provided initializer block
    public func updateCanExecute() {
        self.canExecute.value = self.canExecuteUpdater()
    }

    public func execute(trigger: UIControl?) {
        if self.canExecute.value {
            self.action(trigger)
        }
    }
}