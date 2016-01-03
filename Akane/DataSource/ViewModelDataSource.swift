//
// This file is part of Akane
//
// Created by JC on 30/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol ViewModelDataSource : class {
    typealias DataSourceType: DataSource
    typealias ItemViewModelType: ViewModel

    var dataSource: DataSourceType { get }

    func viewModel(forItem item: DataSourceType.RowItemType) -> ItemViewModelType
//    func viewModel(forSectionItem item: DataSourceType.SectionItemType)
}