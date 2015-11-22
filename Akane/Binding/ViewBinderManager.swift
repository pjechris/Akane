//
// This file is part of Akane
//
// Created by JC on 08/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

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

    func observe<T : Observation>(observable: T) -> ViewObserver<T.Element> {
        let binding = ViewObserver<T.Element>(observable: observable, disposeBag: self.disposeBag)

        self.bindings.append(binding.event)
        return binding
    }

    func observe<T>(observable: EventProducer<T>) -> ViewObserver<T> {
        let binding = ViewObserver<T>.init(event: observable, disposeBag: self.disposeBag)

        self.bindings.append(binding.event)
        return binding
    }

    func bind(viewModel: AnyObject?) {
        self.viewModel = viewModel
    }
}