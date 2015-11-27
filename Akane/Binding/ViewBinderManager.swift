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
 Manage a ViewElement observations with its associated ViewModel. Those observations can be of 2 sorts:

 - a Observation object
 - a Command object

 It then return a Wrapper for each one of them allowing you to plug them with the view.
*/
class ViewBinderManager<View> : ViewBinder {
    typealias ViewElement = View

    internal var viewModel: AnyObject? {
        willSet {
            self.disposeBag = CompositeDisposable()
            self.bindings.removeAll()
        }
    }
    private let view: ViewElement
    private var disposeBag: DisposeBag!
    private var bindings:[AnyObject] = []

    required init(view: ViewElement) {
        self.view = view
    }

    func bind(viewModel: AnyObject?) {
        self.viewModel = viewModel
    }

    func observe<T : Observation>(observable: T) -> ObservationWrapper<T.Element> {
        let binding = ObservationWrapper<T.Element>(observable: observable, disposeBag: self.disposeBag)

        self.bindings.append(binding.event)
        return binding
    }

    func observe<T>(observable: Observable<T>) -> ObservationWrapper<T> {
        let binding = ObservationWrapper<T>(event: observable, disposeBag: self.disposeBag)

        self.bindings.append(binding.event)
        return binding
    }

    func observe<T : Command>(command: T) -> CommandWrapper {
        return CommandWrapper(command: command, disposeBag: self.disposeBag)
    }
}