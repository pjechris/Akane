//
// This file is part of Akane
//
// Created by JC on 08/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

class BondBinderView<View> : BinderView {
    typealias ViewElement = View

    let view: ViewElement
    var viewModel: AnyObject? {
        didSet {
            self.disposeBag = CompositeDisposable()
        }
    }

    var disposeBag: DisposableBag! {
        willSet {
            self.disposeBag?.dispose()
        }
    }

    required init(view: ViewElement) {
        self.view = view
    }

    func observe<T : Observable>(observable: T) -> BondBindingWrapper<T.Element> {
        return BondBindingWrapper<T.Element>(observable: observable, disposeBag: self.disposeBag)
    }
}