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

@synthesize adapter = _adapter;

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

- (AKNTableViewAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[AKNTableViewAdapter alloc] initWithTableView:self lifecycleManager:self.lifecycleManager];
    }

    return _adapter;
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
