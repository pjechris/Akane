//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"

@class AKNTableViewAdapter;

@interface UITableView (Adapter)

@property(nonatomic, strong)AKNTableViewAdapter *adapter;

@end
