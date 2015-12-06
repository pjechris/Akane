//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ViewObserver {
    func observe<T: Observation>(observable: T) -> ObservationWrapper<T.Element>
    func observe<T: Command>(command: T) -> CommandWrapper
}