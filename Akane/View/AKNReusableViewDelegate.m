//
// This file is part of Akane
//
// Created by JC on 25/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNReusableViewDelegate.h"
#import "AKNReusableView.h"
#import "AKNViewConfigurable.h"
#import "AKNViewModel.h"

@implementation AKNReusableViewDelegate

- (void)reuseView:(id<AKNReusableView>)reusableView
    withViewModel:(id<AKNViewModel>)viewModel
      atIndexPath:(NSIndexPath *)indexPath {

    reusableView.itemView.viewModel = viewModel;
}

- (void)mountView:(id<AKNViewConfigurable>)view {
    if ([view.viewModel respondsToSelector:@selector(willMount)]) {
        [view.viewModel willMount];
    }
}

@end
