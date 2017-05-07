//
//  Command.swift
//  Akane
//
//  Created by pjechris on 07/05/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

/**
 A Command is just an action you can execute. It also provides information about
 whether or not this command should be made available to user
 */
public protocol Command {
    /**
     Runs the command action only if `canExecute` is true

     - parameter trigger: The `UIControl` which triggered the command.
     Might be `nil` when triggered programmatically.
     */
    func execute(_ parameter: Any?)
}

extension Command {
    public func execute(_ control: Commandable) {
        self.execute(control.commandParameter)
    }
}
