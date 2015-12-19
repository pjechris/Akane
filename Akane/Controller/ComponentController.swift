//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ComponentController : class {
    typealias ViewType: UIView, ViewComponent

    var componentView: ViewType! { get }
    var viewModel: AKNViewModelProtocol! { get set }

    init(view: ViewType)

    func addController<C:UIViewController where C:ComponentController>(childController: C)

    func controllerForComponent<V:UIView where V:ViewComponent>(component: V) -> ComponentViewController<V>?

    func didLoad()
}