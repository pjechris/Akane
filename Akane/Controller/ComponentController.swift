//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ComponentController : class {
    var componentView: ComponentView! { get }
    var viewModel: AKNViewModelProtocol! { get set }

    init(view: UIView)

    func addController<C:UIViewController where C:ComponentController>(childController: C)

    func controllerForComponent<V:UIView where V:ComponentView>(component: V) -> ComponentViewController?

    func didLoad()
}