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
`ViewObserver` provides an entry point for observing:
- `Command`s
- `ComponentViewModel`s
- any entity conforming to `Observation`
*/
public protocol ViewObserver : class {
    
    /**
    Observes an entity conforming to `Observation`.
     
    - parameter observable: The entity to be observed. Must conform to the 
    `Observation` protocol.
     
    - returns: An `ObservationWrapper` that can be used from within a 
    `ComponentView`.
    */
    func observe<T: Observation>(observable: T) -> ObservationWrapper<T.Element>

    /**
    Observes a `Command`.
     
    - parameter command: The `Command` to be observed.
     
    - returns: A `CommandWrapper`.
    */
    func observe<T: Command>(command: T) -> CommandWrapper

    /**
    Observes an entity conforming to `Observation`.
     
    - parameter observableViewModel: An entity conforming to `Observation` whose
    event is of tpye `ComponentViewModel`.
     
    - returns: A `ViewModelWrapper`
    */
    func observe<T: Observation where T.Element:ComponentViewModel>(observableViewModel: T) -> ViewModelWrapper<T>
    
    /**
    Observes a `ComponentViewModel`.
     
    - parameter viewModel: The `ComponentViewModel` to be observed.
     
    - returns: A `ViewModelWrappr`.
    */
    func observe<T: ComponentViewModel>(viewModel: T) -> ViewModelWrapper<Observable<T>>
}
