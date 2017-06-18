//
// This file is part of Akane
//
// Created by JC on 17/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

@available(*, unavailable, renamed: "TableViewAdapter")
open class TableViewSectionDelegate<DataSourceType : DataSource> : TableViewAdapter<DataSourceType>
{

    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }
}
