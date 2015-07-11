//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UICollectionViewCell+AKNReusableView.h"
#import <objc/runtime.h>

NSString *UICollectionViewCellItemView = @"UICollectionViewCellItemView";

@implementation UICollectionViewCell (AKNReusableView)

- (void)setItemView:(UIView<AKNViewComponent> *)itemView {
    objc_setAssociatedObject(self, &UICollectionViewCellItemView, itemView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView<AKNViewComponent> *)itemView {
    return objc_getAssociatedObject(self, &UICollectionViewCellItemView);
}

@end
