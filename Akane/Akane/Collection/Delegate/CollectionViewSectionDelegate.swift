//
// This file is part of Akane
//
// Created by JC on 24/02/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

@available(*, unavailable, renamed: "CollectionViewAdapter")
open class CollectionViewSectionDelegate<DataSourceType : DataSource> : CollectionViewAdapter<DataSourceType>
{
    public override init(observer: ViewObserver, dataSource: DataSourceType) {
        super.init(observer: observer, dataSource: dataSource)
    }
}
