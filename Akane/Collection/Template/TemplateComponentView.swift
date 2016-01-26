//
// This file is part of Akane
//
// Created by JC on 31/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
 Create templates for `ComponentView`(s)
*/
public class TemplateComponentView<ComponentType: UITableViewCell where ComponentType: ComponentView> : Template {
    public private(set) var nib: UINib?
    public var templateClass: AnyClass { return self.componentViewType }

    private let prepareForReuse: ((UITableViewCell, NSIndexPath) -> Void)?
    private let componentViewType: ComponentType.Type

    public init(_ componentType: ComponentType.Type, fromNib nibName: String?, prepareForReuse: ((UITableViewCell, NSIndexPath) -> Void)? = nil) {
        self.componentViewType = componentType
        self.prepareForReuse = prepareForReuse
        self.nib = nibName.map { return UINib(nibName: $0, bundle: nil) }
    }

    public func bind<O: Observation, V: ComponentViewModel where O.Element == V>(cell: UIView, wrapper: ViewModelWrapper<O>) {
        wrapper.bindTo(cell as! ComponentType)
    }
}