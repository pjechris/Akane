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
    [self configure];

    if (self.window) {
        [self attachViewModel];
    }
}

- (void)configure {
    // Default implementation do nothing
}

- (void)didMoveToWindow {
    if (self.window) {
        [self attachViewModel];
    }
}

// This avoid some conflicts when view is inside a Cell
// Might not be necessary if we define that every AKNView/AKNViewModel is associated to a presenter?
- (void)attachViewModel {
    _viewModel.eventDispatcher = self;
}

@end
