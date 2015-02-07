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
@protocol AKNItemAdapter;
@protocol AKNItemContentProvider;

/**
 * Adapter to transpose UITableViewDataSource and UITableViewDelegate protocols to Adapter protocols
 */
@interface AKNTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong, readonly)id<AKNItemAdapter>            itemAdapter;
@property(nonatomic, strong, readonly)id<AKNItemContentProvider>    contentProvider;
@property(nonatomic, weak)UITableView                               *tableView;

- (instancetype)initWithItemAdapter:(id<AKNItemAdapter>)itemAdapter
                            content:(id<AKNItemContentProvider>)contentProvider;

@end
