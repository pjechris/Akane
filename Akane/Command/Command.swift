//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public protocol Command {
    var canExecute: Observable<Bool> { get }

    func execute(trigger: UIControl)
}