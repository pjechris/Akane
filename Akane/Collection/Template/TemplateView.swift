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
public struct TemplateView : Template {
    public let needsComponentViewModel = false

    public let source: TemplateSource
    public let templateClass: CollectionReusableView.Type

    init(templateClass: CollectionReusableView.Type, from source: TemplateSource = .File()) {
        self.templateClass = templateClass
        self.source = source
    }

    public func bind<O : Observation, V : ComponentViewModel where O.Element == V>(cell: UIView, wrapper: ViewModelWrapper<O>) {
        // no binding
    }
}