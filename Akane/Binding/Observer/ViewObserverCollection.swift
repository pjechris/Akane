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
class ViewObserverCollection : ViewObserver, Dispose {
    var count: Int { return self.bindings.count }
    unowned let lifecycle: Lifecycle

    private var disposeBag: DisposeBag!
    private(set) var bindings:[AnyObject] = []
    private unowned let view: UIView

    init(view: UIView, lifecycle: Lifecycle) {
        self.disposeBag = CompositeDisposable()
        self.view = view
        self.lifecycle = lifecycle
    }

    deinit {
        dispose()
    }

    func dispose() {
        self.disposeBag.dispose()
        self.bindings.removeAll()
    }

    func observe<T : Observation, AttributeType : Any>(observable: T, attribute: T.Element -> AttributeType) -> ObservationWrapper<AttributeType> {
        let wrapper = ObservationWrapper<AttributeType>(observable: observable, attribute: attribute)

        self.disposeBag.addDisposable(wrapper)
        self.bindings.append(wrapper.event)
        return wrapper
    }

    func observe<T : Observation>(observable: T) -> ObservationWrapper<T.Element> {
        return self.observe(observable) { return $0 }
    }

    func observe<T : Command>(command: T) -> CommandWrapper {
        let wrapper = CommandWrapper(command: command)

        self.disposeBag.addDisposable(wrapper)
        return wrapper
    }

    func observe<T: Observation where T.Element: ComponentViewModel>(observableViewModel: T) -> ViewModelWrapper<T> {
        let wrapper = ViewModelWrapper.init(viewModel: observableViewModel, lifecycle: lifecycle)

        self.disposeBag.addDisposable(wrapper)
        return wrapper
    }

    func observe<T: ComponentViewModel>(viewModel: T) -> ViewModelWrapper<Observable<T>> {
        let binding = Observable(viewModel)
        let wrapper = ViewModelWrapper.init(viewModel: binding, lifecycle: lifecycle)

        self.disposeBag.addDisposable(wrapper)
        self.bindings.append(binding)

        return wrapper
    }
}