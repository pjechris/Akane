//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNItemArrayAdapter.h"

@implementation AKNItemArrayAdapter

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (id<AKNViewModel>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (id<AKNViewModel>)itemAtSection:(NSInteger)section {
    return nil;
}

@end
