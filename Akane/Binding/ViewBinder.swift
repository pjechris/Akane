//
// This file is part of Akane
//
// Created by JC on 01/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
**/
public protocol ViewBinder {
    typealias ViewElement

    var viewModel: AnyObject? { get }

    init(view: ViewElement)

    func observe<T: Observation>(observable: T) -> ViewObserver<T.Element>
    func observe<T: Command>(command: T) -> CommandObserver
}