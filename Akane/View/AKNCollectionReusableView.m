//
// This file is part of Akane
//
// Created by Pascal Drouilly on 16/09/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNCollectionReusableView.h"
#import "AKNViewModel.h"

@implementation AKNCollectionReusableView

@synthesize itemView = _itemView;

+ (instancetype)reusableViewWithItemView:(UIView<AKNViewConfigurable> *)itemView {
    return [[self alloc] initWithCellWithItemView:itemView];
}

- (instancetype)initWithCellWithItemView:(UIView<AKNViewConfigurable> *)itemView {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.itemView = itemView;
    
    return self;
}

- (void)setItemView:(UIView<AKNViewConfigurable> *)itemView {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemView);
    
    if (itemView == _itemView) {
        return;
    }
    
    [_itemView removeFromSuperview];
    _itemView = itemView;
    itemView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:itemView];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|"
                                                                 options:0
                                                                 metrics:0
                                                                   views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|"
                                                                 options:0
                                                                 metrics:0
                                                                   views:viewsDictionary]];
}

@end
