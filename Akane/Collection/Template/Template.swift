//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 Define properties of a reusable view element
*/
public protocol Template {
    /// nib to load the template view from
    var nib: UINib? { get }
    /// the template view class type
    var templateClass: AnyClass { get }

    /// make the binding between the reused view and a correspoding `ComponentViewModel`.
    /// - parameter reusedTemplateView: a view created from this `Template`
    /// - parameter wrapper: third-party object to make the binding between the viewModel and the reused view
    func bind<O:Observation, V: ComponentViewModel where O.Element == V>(reusedTemplateView: UIView, wrapper: ViewModelWrapper<O>)
}