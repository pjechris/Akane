//
// This file is part of Akkane
//
// Created by JC on 02/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import "AKNView.h"
#import "AKNViewModel.h"
#import <EventListener.h>

@implementation AKNView

@synthesize componentDelegate   = _componentDelegate;

- (void)setViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    _viewModel = viewModel;
    _viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;

    // BC
    // FIXME Remove this line of code
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

- (id<EVEEventDispatcher>)nextDispatcher {
    return self.viewModel ?: (id<EVEEventDispatcher>)self.nextResponder;
}

- (void)didMoveToSuperview {
	if (self.window && self.nextResponder) {
   		_viewModel.nextDispatcher = (id<EVEEventDispatcher>)self.nextResponder;
	}
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

@end
