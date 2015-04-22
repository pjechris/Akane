//
//  AKNTableView.m
//  Akane
//
//  Created by JC on 27/02/15.
//  Copyright (c) 2015 fr.akane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKNTableView.h"
#import "AKNViewModel.h"
#import <EventListener.h>

@implementation AKNTableView

- (void)setViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    _viewModel = viewModel;
    _viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;
    [self configure];
}

- (void)configure {
    // Default implementation do nothing
}

- (id<EVEEventDispatcher>)nextDispatcher {
    return self.viewModel ?: (id<EVEEventDispatcher>)self.nextResponder;
}

- (void)didMoveToSuperview {
    if (self.window && self.nextResponder) {
        _viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;
    }
}

@end
