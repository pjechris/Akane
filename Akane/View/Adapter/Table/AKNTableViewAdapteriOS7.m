//
// This file is part of Akane
//
// Created by JC on 22/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewAdapteriOS7.h"
#import "AKNViewConfigurable.h"
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNViewCache.h"
#import "AKNItemViewModel.h"
#import <objc/runtime.h>
#import "AKNTableViewCell.h"
#import "AKNTableViewAdapter+Private.h"

CGFloat const TableViewAdapterDefaultRowHeight = 44.f;

@interface AKNTableViewAdapteriOS7 ()
@property(nonatomic, strong)NSMutableDictionary *cellsQueue;
@end

@implementation AKNTableViewAdapteriOS7

- (instancetype)initCluster {
    if (!(self = [super initCluster])) {
        return nil;
    }

    self.cellsQueue = [NSMutableDictionary new];

    return self;
}

#pragma mark - Table delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    [self removeFromQueueReusableCellForIndexPath:indexPath];
    [self repositionFooter];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.itemViewModelProvider viewIdentifier:viewModel];
    AKNTableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    [self queueReusableCell:cell forIndexPath:indexPath];

    [cell attachViewModel:viewModel];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    if (height == 0) {
        NSLog(@"Detected a case where constraints ambiguously suggest a height of zero for a tableview cell's content view.\
              We're considering the collapse unintentional and using %f height instead", TableViewAdapterDefaultRowHeight);

        height = TableViewAdapterDefaultRowHeight;
    }

    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<AKNItemViewModel> sectionViewModel = [self sectionModel:section];
    NSString *identifier = [self.itemViewModelProvider supplementaryViewIdentifier:sectionViewModel];
    identifier = [identifier stringByAppendingString:UICollectionElementKindSectionHeader];

    if (!identifier) {
        return 0;
    }

    UIView<AKNViewConfigurable> *sectionView = [self dequeueReusableSectionWithIdentifier:identifier forSection:section];
    sectionView.viewModel = sectionViewModel;

    return [sectionView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

#pragma mark - Internal

/**
 * iOS7 compatibility
 * Footer is positioned based on estimatedRowHeight
 * Thus if your content is longer than your estimated size, your footer will be misplaced...
 */
- (void)repositionFooter {
    UIView *footer = self.tableView.tableFooterView;

    self.tableView.tableFooterView = footer;
}

- (AKNTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    AKNTableViewCell *cell = self.cellsQueue[indexPath];

    if (!cell) {
        cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }

    return cell;
}

- (void)queueReusableCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    self.cellsQueue[indexPath] = cell;
}

- (void)removeFromQueueReusableCellForIndexPath:(NSIndexPath *)indexPath {
    [self.cellsQueue removeObjectForKey:indexPath];
}

@end
