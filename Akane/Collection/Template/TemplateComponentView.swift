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
public struct TemplateComponentView<ComponentType : UIView where ComponentType : protocol<CollectionReusableView, ComponentView>> : Template {
    public let needsComponentViewModel = true

    public let source: TemplateSource
    public var templateClass: CollectionReusableView.Type { return self.componentViewType }

    private let prepareForReuse: ((CollectionReusableView, NSIndexPath) -> Void)?
    private let componentViewType: ComponentType.Type

    public init(_ componentType: ComponentType.Type, from source: TemplateSource = .File()) {
        self.componentViewType = componentType
        self.source = source
        self.prepareForReuse = nil
    }

    public func bind<V: ComponentViewModel>(cell: UIView, wrapper: ViewModelObserver<V>) {
        wrapper.bindTo(cell as! ComponentType)
    }
}