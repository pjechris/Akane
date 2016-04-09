//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
Define properties of a reusable collection view
*/
public protocol Template {
    /// source to load the template view from
    var source: TemplateSource { get }

    /// the template view class type
    var templateClass: CollectionReusableView.Type { get }

    var needsComponentViewModel: Bool { get }

    /// make the binding between the reused view and a correspoding `ComponentViewModel`.
    /// - parameter reusedTemplateView: a view created from this `Template`
    /// - parameter wrapper: third-party object to make the binding between the viewModel and the reused view
    func bind<V: ComponentViewModel>(reusedTemplateView: UIView, wrapper: ViewModelObserver<V>)
}

/// Define Sources from which a Template can be created
public enum TemplateSource {
    case Nib(UINib)
    case StoryboardId(String)
    case File()
}