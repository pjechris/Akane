//
// This file is part of Akkane
//
// Created by JC on 02/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNView.h"

@implementation AKNView

- (void)setViewModel:(id<AKNViewModel>)viewModel {
    if (viewModel == _viewModel) {
        return;
    }

    _viewModel = viewModel;
    [self configure];
}

- (void)configure {
    // Default implementation do nothing
}

@end
