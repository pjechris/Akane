//
// This file is part of Akane
//
// Created by JC on 22/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewAdapteriOS7.h"
#import "AKNTableViewAdapter+Private.h"
#import "AKNViewConfigurable.h"
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNViewCache.h"
#import "AKNItemViewModel.h"
#import "AKNTableViewCell.h"
#import "AKNReusableViewHandler.h"
#import "AKNReusableViewDelegate.h"
#import <objc/runtime.h>

CGFloat const TableViewAdapterDefaultRowHeight = 44.f;

@interface AKNTableViewAdapteriOS7 ()
@property(nonatomic, strong)NSMutableDictionary *cellsQueue;
@end

@implementation AKNTableViewAdapteriOS7

- (void)customInit {
    self.cellsQueue = [NSMutableDictionary new];
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
    CGFloat height = [objc_getAssociatedObject(viewModel, (__bridge const void *)(identifier)) floatValue];

    if (!height) {
        UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

        [self queueReusableCell:cell forIndexPath:indexPath];
        [self.viewDelegate reuseView:cell withViewModel:viewModel atIndexPath:indexPath];

        [cell setNeedsLayout];
        [cell layoutIfNeeded];

        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

        if (height == 0) {
            NSLog(@"Detected a case where constraints ambiguously suggest a height of zero for a tableview cell's content view.\
                  We're considering the collapse unintentional and using %f height instead", TableViewAdapterDefaultRowHeight);

            height = TableViewAdapterDefaultRowHeight;
        }

        objc_setAssociatedObject(viewModel, (__bridge const void *)(identifier), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return height + 1;
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

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cellsQueue[indexPath];

    if (!cell || ![cell.reuseIdentifier isEqualToString:identifier]) {
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
