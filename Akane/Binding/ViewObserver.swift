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
 Propose an View oriented Observation API. You can observe 3 types of elements:
 - Command
 - ViewModel
 - Observation

 Those are the elements you can observe **from** a ```UIView```. For each one of them you get an associated wrapper:
 - CommandWrapper
 - ObservationWrapper
 - ViewModelWrapper
 Those wrappers contain restricted APIs to manipulate your observation object, again from a UIView perspective.
 
 For instance you ```ObservationWrapper``` has ```convert``` method to convert your ```Observation``` while ```CommandWrapper``` does not.

*/
public protocol ViewObserver {
    func observe<T: Observation>(observable: T) -> ObservationWrapper<T.Element>

    func observe<T: Command>(command: T) -> CommandWrapper

    func observe<T: Observation where T.Element:ViewModel>(observableViewModel: T) -> ViewModelWrapper<T>
    func observe<T:ViewModel>(viewModel: T) -> ViewModelWrapper<Observable<T>>
}