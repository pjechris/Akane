//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol DataSource {
    typealias DataType

    init(data: DataType)

    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
}

public extension DataSource {
    func numberOfSections() -> Int {
        return 1
    }
}

