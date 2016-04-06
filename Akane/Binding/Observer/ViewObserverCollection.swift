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

    private(set) var bindings:[AnyObject] = []
    private unowned let view: UIView

    init(view: UIView, lifecycle: Lifecycle) {
        self.view = view
        self.lifecycle = lifecycle
    }

    deinit {
    }

    func dispose() {
        // call unbind/unobserve on all observers/bindings
        self.bindings.removeAll()
    }

    func observe<AnyValue>(value: AnyValue) -> AnyBinding<AnyValue> {
        let binding = AnyBinding(value: value)

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

//    func observe<T : Command>(command: T) -> CommandWrapper {
//        let wrapper = CommandWrapper(command: command)
//
//        self.disposeBag.addDisposable(wrapper)
//        return wrapper
//    }

//    func observe<T: Observation where T.Element: ComponentViewModel>(observableViewModel: T) -> ViewModelWrapper<T> {
//        let wrapper = ViewModelWrapper.init(viewModel: observableViewModel, lifecycle: lifecycle)
//
//        self.disposeBag.addDisposable(wrapper)
//        return wrapper
//    }
//
//    func observe<T: ComponentViewModel>(viewModel: T) -> ViewModelWrapper<Observable<T>> {
//        let binding = Observable(viewModel)
//        let wrapper = ViewModelWrapper.init(viewModel: binding, lifecycle: lifecycle)
//
//        self.disposeBag.addDisposable(wrapper)
//        self.bindings.append(binding)
//
//        return wrapper
//    }
}