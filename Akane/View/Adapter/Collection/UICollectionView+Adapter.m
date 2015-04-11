//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UICollectionView+Adapter.h"
#import "AKNCollectionViewAdapter.h"
#import <objc/runtime.h>

NSString *const UICollectionViewAdapter;

@implementation UICollectionView (Adapter)

- (AKNCollectionViewAdapter *)adapter {
    AKNCollectionViewAdapter *adapter = objc_getAssociatedObject(self, &UICollectionViewAdapter);
    
    if (!adapter) {
        adapter = [[AKNCollectionViewAdapter alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, &UICollectionViewAdapter, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
