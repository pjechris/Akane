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
#import "AKNTableViewAdapter.h"
#import <EventListener.h>

@implementation AKNTableView

@synthesize adapter             = _adapter;
@synthesize componentDelegate   = _componentDelegate;

- (void)setViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    _viewModel = viewModel;
    _viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;

    // BC
    // FIXME Remove this line of code
    [self configure];
}

- (void)configure {
    // Default implementation do nothing
}

- (void)bind:(id<AKNViewModel>)viewModel {
    // BC => will be removed!
    self.viewModel = viewModel;

    [[self superComponentDelegate] viewComponent:self isBindedTo:viewModel];
}

- (id<AKNViewComponentDelegate>)superComponentDelegate {
    UIView *superview = self.superview;

    while (superview) {
        if ([superview conformsToProtocol:@protocol(AKNViewComponent)]) {
            return ((id<AKNViewComponent>)superview).componentDelegate;
        }

        superview = superview.superview;
    }

    return nil;
}

- (id<EVEEventDispatcher>)nextDispatcher {
    return self.viewModel ?: (id<EVEEventDispatcher>)self.nextResponder;
}

- (void)didMoveToSuperview {
    if (self.window && self.nextResponder) {
        _viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;
    }
}

#pragma mark - Table Adapter

- (AKNTableViewAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[AKNTableViewAdapter alloc] initWithTableView:self];
    }
    
    return _adapter;
}

- (void)setAdapter:(AKNTableViewAdapter *)adapter {
    _adapter = adapter;
}

- (void)setAdapterDataSource:(id<AKNDataSource>)adapterDataSource {
    self.adapter.dataSource = adapterDataSource;
}

- (void)setAdapterItemProvider:(id<AKNItemViewModelProvider>)adapterItemProvider {
    self.adapter.itemViewModelProvider = adapterItemProvider;
}

- (id<AKNDataSource>)adapterDataSource {
    return self.adapter.dataSource;
}

- (id<AKNItemViewModelProvider>)adapterItemProvider {
    return self.adapter.itemViewModelProvider;
}

@end
