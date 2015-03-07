//
//  AKNTableView.m
//  Akane
//
//  Created by JC on 27/02/15.
//  Copyright (c) 2015 fr.akane. All rights reserved.
//

#import "AKNTableView.h"
#import "AKNViewModel.h"
#import <EventListener.h>

@implementation AKNTableView

- (void)setViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    _viewModel = viewModel;
    _viewModel.eventDispatcher = self;
    [self configure];
}

- (void)configure {
    // Default implementation do nothing
}

@end
