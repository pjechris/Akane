//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import "AKNCollectionView.h"
#import "AKNViewModel.h"
#import "UICollectionView+Adapter.h"
#import "AKNCollectionViewAdapter.h"
#import <EventListener.h>

@implementation AKNCollectionView

@synthesize adapter             = _adapter;
@synthesize componentDelegate   = _componentDelegate;

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

- (void)bind:(id<AKNViewModel>)viewModel {
    // BC => will be removed!
    self.viewModel = viewModel;
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

- (AKNCollectionViewAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[AKNCollectionViewAdapter alloc] initWithCollectionView:self];
    }

    return _adapter;
}

- (void)setAdapter:(AKNCollectionViewAdapter *)adapter {
    _adapter = adapter;
}

@end
