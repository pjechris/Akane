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
 Contain multiple `Observer` instances which can be disposed at any time
*/
class ViewObserverCollection : ViewObserver {
    unowned let lifecycle: Lifecycle

    private unowned let view: UIView

    init(view: UIView, lifecycle: Lifecycle) {
        self.view = view
        self.lifecycle = lifecycle
    }

    deinit {
        self.removeAllObservers()
    }

    func unobserve() {
        self.removeAllObservers()
    }

    func observe<AnyValue>(value: AnyValue) -> AnyObserver<AnyValue> {
        let observer = AnyObserver(value: value)

        self.append(observer)

        return observer
    }

    func observe(value: Command) -> CommandObserver {
        let observer = CommandObserver(command: value)

        self.append(observer)

        return observer
    }

    func observe<ViewModelType: ComponentViewModel>(value: ViewModelType) -> ViewModelObserver<ViewModelType> {
        let observer = ViewModelObserver<ViewModelType>(lifecycle: self.lifecycle)

        self.append(observer)

        return observer
    }
}