//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

/**
Default implementation of `ComponentController`.
*/
class DefaultViewController<ComponentViewType: ComponentDisplayable> : UIViewController, ComponentController {
    typealias ViewType = ComponentViewType

    init(view: ViewType) {
        super.init(nibName: nil, bundle: nil)
        self.replace(view: view as! UIView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIViewController {
    func replace(view: UIView) {
        let needsDidLoad = !self.isViewLoaded

        self.view = view
        if needsDidLoad {
            self.viewDidLoad()
        }
    }
}


