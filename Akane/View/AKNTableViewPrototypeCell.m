//
//  AKNTableViewPrototypeCell.m
//  Akane
//
//  Created by JC on 07/03/15.
//  Copyright (c) 2015 fr.akane. All rights reserved.
//

#import "AKNTableViewPrototypeCell.h"
#import "AKNViewModel.h"

@implementation AKNTableViewPrototypeCell

/// Fix for event dispatcher
/// TO REMOVE!
- (void)attachViewModel:(id<AKNViewModel>)viewModel {
    id<EVEEventDispatcher> dispatcher = viewModel.nextDispatcher;

    self.aknContentView.viewModel = viewModel;

    viewModel.nextDispatcher = dispatcher;
}

@end
