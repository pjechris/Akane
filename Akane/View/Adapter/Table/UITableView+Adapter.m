//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UITableView+Adapter.h"
#import "AKNTableViewAdapter.h"
#import <objc/runtime.h>

NSString *const UITableViewAdapter;

@implementation UITableView (Adapter)

- (AKNTableViewAdapter *)adapter {
    AKNTableViewAdapter *adapter = objc_getAssociatedObject(self, &UITableViewAdapter);

    if (!adapter) {
        adapter = [[AKNTableViewAdapter alloc] initWithTableView:self];
        objc_setAssociatedObject(self, &UITableViewAdapter, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return adapter;
}

- (void)setAdapterDataSource:(id<AKNDataSource>)adapterDataSource {
    [self adapter].dataSource = adapterDataSource;
}

- (void)setAdapterItemProvider:(id<AKNItemViewModelProvider>)adapterItemProvider {
    [self adapter].itemViewModelProvider = adapterItemProvider;
}

- (id<AKNDataSource>)adapterDataSource {
    return [self adapter].dataSource;
}

- (id<AKNItemViewModelProvider>)adapterItemProvider {
    return [self adapter].itemViewModelProvider;
}

@end
