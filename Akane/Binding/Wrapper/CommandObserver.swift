//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class CommandObserver : Observer {
    var value: Command? = nil {
        didSet { self.runNext() }
    }

    var next: [(Command -> Void)] = [] {
        didSet { self.runNext() }
    }

    private var controls: [UIControl] = []

    init(command: Command) {
        self.value = command
    }

    deinit {
        self.unobserve()
    }

    func unobserve() {
        for control in self.controls {
            control.removeTarget(self, action: nil, forControlEvents: .AllEvents)
        }

        self.controls = []
        self.next = []
        self.value = nil
    }
}

extension CommandObserver {
    public func bindTo(control: UIControl?, events: UIControlEvents = .TouchUpInside) {
        if let control = control {
            self.bindTo(control, events: events)
        }
    }

    public func bindTo(control: UIControl, events: UIControlEvents = .TouchUpInside) {
        control.addTarget(self, action: "onTouch", forControlEvents: events)

        self.controls.append(control)
    }

    @objc
    func onTouch(sender: UIControl) {
        self.value?.execute(sender)
    }
}