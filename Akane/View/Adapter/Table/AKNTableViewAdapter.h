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

/**
 * Adapter to transpose UITableViewDataSource and UITableViewDelegate protocols to Adapter protocols
 */
@interface AKNTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong, readonly)id<AKNDataSource>             dataSource;
@property(nonatomic, strong, readonly)id<AKNItemViewModelProvider>  itemViewModelProvider;
@property(nonatomic, weak)UITableView                               *tableView;

- (instancetype)initWithDataSource:(id<AKNDataSource>)dataSource
                 viewModelProvider:(id<AKNItemViewModelProvider>)itemViewModelProvider;

@end
