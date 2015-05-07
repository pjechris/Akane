//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNCollectionViewCell.h"
#import "AKNViewModel.h"

@implementation AKNCollectionViewCell

@synthesize itemView = _itemView;

+ (instancetype)cellWithItemView:(UIView<AKNViewConfigurable> *)itemView {
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
    
    [self.contentView addSubview:itemView];
    // iOS7 compatibility
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
}

@end
