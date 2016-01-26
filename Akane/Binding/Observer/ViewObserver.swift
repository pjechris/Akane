//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
 View observation API allowing you to observe:
 - `Command`
 - `ComponentViewModel`
 - any conforming `Observation`

*/
public protocol ViewObserver : class {
    func observe<T: Observation>(observable: T) -> ObservationWrapper<T.Element>

    func observe<T: Command>(command: T) -> CommandWrapper

    func observe<T: Observation where T.Element:ComponentViewModel>(observableViewModel: T) -> ViewModelWrapper<T>
    func observe<T: ComponentViewModel>(viewModel: T) -> ViewModelWrapper<Observable<T>>
}