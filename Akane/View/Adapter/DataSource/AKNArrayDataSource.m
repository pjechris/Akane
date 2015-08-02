//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNArrayDataSource.h"
#import <UIKit/UIKit.h>

@implementation AKNArrayDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (nullable id)supplementaryItemAtSection:(NSInteger)section {
    return nil;
}

- (nonnull id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return self.items[indexPath.row];
}

@end
