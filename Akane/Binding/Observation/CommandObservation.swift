//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class CommandObservation : Observation {
    var value: Command? = nil

    var next: [(Command -> Void)] = []

    private var controls: [UIControl] = []

    var canExecuteObservation: AnyObservation<Bool>? = nil
    var isExecutingObservation: AnyObservation<Bool>? = nil

    init(command: Command, observer: ViewObserver?) {
        self.value = command

        self.canExecuteObservation = observer?.observe(command.canExecute)

        if let asyncCommand = command as? AsyncCommand {
            self.isExecutingObservation = observer?.observe(asyncCommand.isExecuting)
        }
    }

    deinit {
        self.unobserve()
    }

    func unobserve() {
        for control in self.controls {
            control.removeTarget(self, action: nil, forControlEvents: .AllEvents)
        }

        self.canExecuteObservation?.unobserve()
        self.isExecutingObservation?.unobserve()

        self.controls = []
        self.next = []
        self.value = nil
    }
}

extension CommandObservation {
    public func bindTo(control: UIControl?, events: UIControlEvents = .TouchUpInside) {
        if let control = control {
            self.bindTo(control, events: events)
        }
    }

    /**
     Binds command on `control`. It also attaches:
     - command `canExecute` with control `enabled`
     - command `isExecuting` (if AsyncCommand) with control `userInteractionEnabled`
     */
    public func bindTo(control: UIControl, events: UIControlEvents = .TouchUpInside) {
        control.addTarget(self, action: "onTouch", forControlEvents: events)

        self.controls.append(control)

        // FIXME remove dep on Bond
        self.canExecuteObservation?.bindTo(control.bnd_enabled)
        self.isExecutingObservation?.bindTo(control.bnd_userInteractionEnabled)
    }

    @objc
    func onTouch(sender: UIControl) {
        self.value?.execute(sender)
    }
}