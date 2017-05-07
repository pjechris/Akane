//
//  Commandable.swift
//  Akane
//
//  Created by pjechris on 12/09/16.
//  Copyright © 2016 fr.akane. All rights reserved.
//

import Foundation
#if !COCOAPODS
    import Akane
#endif

/**
 Passing an object conforming to this protocol to `Command` passes its value to `Command.execute`.
 Some UIKit views are made `Commandable`:
 - UITextField
 - UIStepper
 - UISlider
 - UISwitch
 - UISegmentedControl

 **/
public protocol Commandable {
    var commandParameter: Any? { get }
}

extension UITextField : Commandable {
    public var commandParameter: Any? {
        return self.text
    }
}

extension UIStepper : Commandable {
    public var commandParameter: Any? {
        return self.value
    }
}

extension UISlider : Commandable {
    public var commandParameter: Any? {
        return self.value
    }
}

extension UISwitch : Commandable {
    public var commandParameter: Any? {
        return self.isOn
    }
}

extension UISegmentedControl : Commandable {
    public var commandParameter: Any? {
        return self.selectedSegmentIndex
    }
}
