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
}

- (void)bind:(id<AKNViewModel>)viewModel to:(UIView<AKNViewComponent> *)viewComponent {
    [self.componentDelegate viewComponent:viewComponent isBindedTo:viewModel];
}

- (id<EVEEventDispatcher>)nextDispatcher {
    return self.viewModel ?: (id<EVEEventDispatcher>)self.nextResponder;
}

@end
