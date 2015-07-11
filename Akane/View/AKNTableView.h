//
//  AKNTableView.h
//  Akane
//
//  Created by JC on 27/02/15.
//  Copyright (c) 2015 fr.akane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewComponent.h"
#import "AKNLifecycleManager.h"
#import "UITableView+Adapter.h"

@interface AKNTableView : UITableView<AKNViewComponent>

@property(nonatomic, weak)id<AKNViewModel>      viewModel;

@property(nonatomic, strong)AKNTableViewAdapter *adapter;

@end
