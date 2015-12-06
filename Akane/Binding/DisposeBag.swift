//
// This file is part of Akane
//
// Created by JC on 05/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

protocol DisposeBag : Dispose {
    func addDisposable(disposable: Dispose)
}