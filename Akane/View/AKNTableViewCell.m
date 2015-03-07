//
// This file is part of Akkane
//
// Created by JC on 07/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewCell.h"
#import "AKNViewModel.h"

@implementation AKNTableViewCell

/// Fix for event dispatcher
/// TO REMOVE!
- (void)attachViewModel:(id<AKNViewModel>)viewModel {
    self.aknContentView.viewModel = viewModel;

    if ([viewModel respondsToSelector:@selector(willMount)]) {
        [viewModel willMount];
    }
}

- (void)setAknContentView:(UIView<AKNViewConfigurable> *)aknContentView {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(aknContentView);

    if (aknContentView == _aknContentView) {
        return;
    }

    [_aknContentView removeFromSuperview];
    _aknContentView = aknContentView;
    aknContentView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:aknContentView];
    // iOS7 compatibility
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aknContentView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aknContentView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
}

@end
