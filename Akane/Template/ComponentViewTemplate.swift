//
// This file is part of Akane
//
// Created by JC on 31/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public class ComponentViewTemplate<ComponentType: UITableViewCell where ComponentType: ComponentView> : Template {
    let prepareForReuse: ((UITableViewCell, NSIndexPath) -> Void)?
    let componentViewType: ComponentType.Type

    public init(_ componentType: ComponentType.Type, prepareForReuse: ((UITableViewCell, NSIndexPath) -> Void)? = nil) {
        self.componentViewType = componentType
        self.prepareForReuse = prepareForReuse
    }

    public func bind<O: Observation, V: ViewModel where O.Element == V>(cell: UITableViewCell, wrapper: ViewModelWrapper<O>) {
        wrapper.bindTo(cell as? ComponentType)
    }

    public func register(table: UITableView, identifier: String) {
        table.registerClass(self.componentViewType, forCellReuseIdentifier: identifier)
    }
}