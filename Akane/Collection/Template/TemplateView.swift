//
// This file is part of Akane
//
// Created by JC on 25/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 Create templates for simple `UIView`s
*/
public class TemplateView : Template {
    public let nib: UINib?
    public let templateClass: AnyClass

    init(templateClass: AnyClass, nibName: String) {
        self.templateClass = templateClass
        self.nib = UINib(nibName: nibName, bundle: nil)
    }

    public func bind<O : Observation, V : ComponentViewModel where O.Element == V>(cell: UIView, wrapper: ViewModelWrapper<O>) {
        // no binding
    }
}