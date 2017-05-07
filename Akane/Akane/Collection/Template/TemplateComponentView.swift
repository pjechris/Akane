//
// This file is part of Akane
//
// Created by JC on 31/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import UIKit

/**
 Create templates for `ComponentView`(s)
*/
public struct TemplateComponentView<ComponentType : UIView> : Template where ComponentType : CollectionReusableView & ComponentView {
    public let needsComponentViewModel = true

    public let source: TemplateSource
    public var templateClass: CollectionReusableView.Type { return self.componentViewType }

    fileprivate let prepareForReuse: ((CollectionReusableView, IndexPath) -> Void)?
    fileprivate let componentViewType: ComponentType.Type

    public init(_ componentType: ComponentType.Type, from source: TemplateSource = .file()) {
        self.componentViewType = componentType
        self.source = source
        self.prepareForReuse = nil
    }

    public func bind<V: ComponentViewModel>(_ cell: UIView, wrapper: ViewModelObservation<V>) {
        wrapper.bind(to: cell as! ComponentType)
    }
}
