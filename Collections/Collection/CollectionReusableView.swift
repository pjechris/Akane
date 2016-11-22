//
// This file is part of Akane
//
// Created by JC on 23/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol CollectionReusableView : class {
    /// A string that identifies the purpose of the view
    var reuseIdentifier: String? { get }

    /// Performs any clean up necessary to prepare the view for use again.s
    func prepareForReuse()
}