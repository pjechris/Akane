//
// This file is part of Akane
//
// Created by JC on 08/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
 Contain multiple `ViewObserver` instances which can be disposed at any time
*/
class ViewObserverCollection : ViewObserver {
    var count: Int { return self.bindings.count }
    unowned let lifecycle: Lifecycle

    private(set) var bindings:[_Observer] = []
    private unowned let view: UIView

    init(view: UIView, lifecycle: Lifecycle) {
        self.view = view
        self.lifecycle = lifecycle
    }

    deinit {
    }

    func unobserve() {
        self.bindings.removeAll()
    }

    func observe<AnyValue>(value: AnyValue) -> AnyObserver<AnyValue> {
        let binding = AnyObserver(value: value)

        self.bindings.append(binding)

        return binding
    }

    func observe(value: Command) -> CommandObserver {
        let observer = CommandObserver(command: value)

        self.bindings.append(observer)

        return observer
    }

    func observe<ViewModelType: ComponentViewModel>(value: ViewModelType) -> ViewModelObserver<ViewModelType> {
        let observer = ViewModelObserver<ViewModelType>(lifecycle: self.lifecycle)

        self.bindings.append(observer)

        return observer
    }
}