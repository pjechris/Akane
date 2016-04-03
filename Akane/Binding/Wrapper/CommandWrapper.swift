//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class CommandWrapper {
    let command: Command
    private let disposeBag: DisposeBag

    init(command: Command) {
        self.command = command
        self.disposeBag = CompositeDisposable()
    }

    public func bindTo(control: UIControl?, events: UIControlEvents = .TouchUpInside) {
        if let control = control {
            self.bindTo(control, events: events)
        }
    }

    public func bindTo(control: UIControl, events: UIControlEvents = .TouchUpInside) {
        let command = self.command
        let enabled = command.canExecute.bindTo(control.bnd_enabled)
        let action = control.bnd_controlEvent
            .filter { $0 == events }
            .observe { [unowned control] _ in command.execute(control) }

        self.disposeBag.addDisposable(BondDisposeAdapter(enabled))
        self.disposeBag.addDisposable(BondDisposeAdapter(action))
    }
}

extension CommandWrapper : Dispose {
    public func dispose() {
        self.disposeBag.dispose()
    }
}