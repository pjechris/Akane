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
#import "AKNPresenterViewController.h"

@implementation AKNView

@synthesize componentDelegate   = _componentDelegate;

- (void)bind:(nullable id<AKNViewModel>)viewModel {
}

- (void)bind:(nullable id<AKNViewModel>)viewModel to:(nullable UIView<AKNViewComponent> *)viewComponent {
    if (viewComponent) {
        [self.componentDelegate viewComponent:viewComponent isBindedTo:viewModel];
    }
}

+ (Class)componentPresenterClass {
    return AKNPresenterViewController.class;
}

@end
