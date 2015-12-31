//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol Template {
    func bind<O:Observation, V:ViewModel where O.Element == V>(cell: UITableViewCell, wrapper: ViewModelWrapper<O>)
    func register(table: UITableView, identifier: String)
}