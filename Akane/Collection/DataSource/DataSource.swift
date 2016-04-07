//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/// Provide the data required by a collection view.
public protocol DataSource {
    /// Ask the number of sections available into the data
    func numberOfSections() -> Int

    /// Ask the number of items contained into a section
    func numberOfItemsInSection(section: Int) -> Int
}

public extension DataSource {
    /// return one section
    func numberOfSections() -> Int {
        return 1
    }
}

