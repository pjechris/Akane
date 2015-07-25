//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AKNViewModel;
@protocol AKNDataSource;
@protocol AKNItemViewModelProvider;
@class AKNLifecycleManager;

/**
 * Adapter to transpose UITableViewDataSource and UITableViewDelegate protocols to Adapter protocols
 */
@interface AKNTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)id<AKNDataSource>               dataSource;
@property(nonatomic, strong)id<AKNItemViewModelProvider>    itemViewModelProvider;
@property(nonatomic, weak, readonly)UITableView             *tableView;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithTableView:(UITableView *)tableView;

@end
