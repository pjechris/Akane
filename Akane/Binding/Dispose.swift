//
// This file is part of Akane
//
// Created by JC on 05/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Object conforming to this protocol can dispose or cancel a connection or a task.
public protocol Dispose {
    func dispose()
}