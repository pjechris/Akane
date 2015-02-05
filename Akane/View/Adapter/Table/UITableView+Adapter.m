//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UITableView+Adapter.h"
#import "AKNTableViewAdapter.h"
#import "AKNItemViewProvider.h"
#import <objc/runtime.h>

NSString *const UITableViewAdapter;

@implementation UITableView (Adapter)

- (void)setAdapter:(AKNTableViewAdapter *)adapter {
    objc_setAssociatedObject(self, &UITableViewAdapter, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [adapter.itemViewProvider provideTableView:self];

    self.dataSource = adapter;
    self.delegate = adapter;
}

- (AKNTableViewAdapter *)adapter {
    return objc_getAssociatedObject(self, &UITableViewAdapter);
}

@end
