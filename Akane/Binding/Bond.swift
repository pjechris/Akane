//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

extension Bond.Observable : Akane.Bindable {
    public func advance() -> (Element -> Void) {
        return self.sink(nil)
    }
}

extension CompositeDisposable : DisposeBag {
    func addDisposable(disposable: Dispose) {
        self.addDisposable(BlockDisposable() { disposable.dispose() })
    }
}

extension Bond.Observable : Observation {
    public typealias Element = EventType

    public func observe(observer: Element -> ()) -> Dispose {
        let dispose: DisposableType = self.observe { value in
            observer(value)
        }

        return BondDisposeAdapter(dispose)
    }
}