//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class RelayCommand : Command {
    public private(set) var canExecute : Observable<Bool> = Observable(true)
    private let action: (UIControl) -> ()
    private let canExecuteUpdater: () -> Bool

    public init(canExecute canExecuteUpdater: () -> Bool, _ action: (UIControl) -> ()) {
        self.canExecuteUpdater = canExecuteUpdater
        self.action = action
    }

    public convenience init(_ action: (UIControl) -> ()) {
        self.init(canExecute: { return true }, action)
    }

    public func updateCanExecute() {
        self.canExecute.value = self.canExecuteUpdater()
    }

    public func execute(trigger: UIControl) {
        if self.canExecute.value {
            self.action(trigger)
        }
    }
}