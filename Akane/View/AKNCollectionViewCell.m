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

+ (instancetype)cellWithItemView:(UIView<AKNViewComponent> *)itemView {
    return [[self alloc] initWithCellWithItemView:itemView];
}

- (instancetype)initWithCellWithItemView:(UIView<AKNViewComponent> *)itemView {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.itemView = itemView;
    
    return self;
}

- (void)setItemView:(UIView<AKNViewComponent> *)itemView {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemView);
    
    if (itemView == _itemView) {
        return;
    }
    
    [_itemView removeFromSuperview];
    _itemView = itemView;
    itemView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:itemView];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:viewsDictionary]];

    // TODO should we wrap it in a 'if IOS 7' at minimum ? Also seems to serve no purpose when tested without it.
    // iOS7 compatibility
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

@end
