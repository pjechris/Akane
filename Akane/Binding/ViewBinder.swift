//
// This file is part of Akane
//
// Created by JC on 01/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ViewBinder {
    typealias ViewElement

    var viewModel: AnyObject? { get }

    init(view: ViewElement)
    func bind(viewModel: AnyObject?)

    func observe<T: Observation>(observable: T) -> ObservationWrapper<T.Element>
    func observe<T: Command>(command: T) -> CommandWrapper
}