//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

extension UIViewController {
    func replace(view: UIView) {
        let needsDidLoad = !self.isViewLoaded

        self.view = view
        if needsDidLoad {
            self.viewDidLoad()
        }
    }
}


