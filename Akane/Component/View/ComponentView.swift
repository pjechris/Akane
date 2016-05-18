//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

var ComponentViewLifecycleAttr = "ComponentViewLifecycleAttr"

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.

- *Future enhancements:* this protocol will be generic once we will be able to 
use generics with Storyboard/Xib
*/
public protocol ComponentView : class, ViewObserver, HasAssociatedObjects {
    /**
    Define the bindings between the fields (IBOutlet) and the ComponentViewModel
    
    - parameter observer:  The observer to use for defining  and registering 
    bindings
    - parameter viewModel: The `ComponentViewModel` associated to the `UIView`
    */
    func bindings(observer: ViewObserver, viewModel: AnyObject)

    /**
     `ComponentViewController` class associated to the `ComponentView`

     - returns: The `ComponentViewController` type.
     The Default implementation returns `ComponentViewController.self`
     */
    static func componentControllerClass() -> ComponentViewController.Type
}

extension ComponentView {
    public weak var componentLifecycle: Lifecycle? {
        get {
            guard let weakValue = self.associatedObjects[ComponentViewLifecycleAttr] as? AnyWeakValue else {
                return nil
            }

            return weakValue.value as? Lifecycle
        }
        set { self.associatedObjects[ComponentViewLifecycleAttr] = AnyWeakValue(newValue) }
    }

    public static func componentControllerClass() -> ComponentViewController.Type {
        return ComponentViewController.self
    }
}

extension ComponentView {
    public func observe<AnyValue>(value: AnyValue) -> AnyObservation<AnyValue> {
        let observation = AnyObservation(value: value)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe(value: Command) -> CommandObservation {
        let observation = CommandObservation(command: value)

        self.observerCollection?.append(observation)

        return observation
    }

    public func observe<ViewModelType : ComponentViewModel>(value: ViewModelType) -> ViewModelObservation<ViewModelType> {
        let observation = ViewModelObservation<ViewModelType>(lifecycle: self.componentLifecycle!)

        self.observerCollection?.append(observation)

        return observation
    }
}