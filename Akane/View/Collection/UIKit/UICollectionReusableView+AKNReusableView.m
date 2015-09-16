//
// This file is part of Akane
//
// Created by Pascal Drouilly on 16/09/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UICollectionReusableView+AKNReusableView.h"
#import <objc/runtime.h>

NSString *UICollectionReusableViewItemView = @"UICollectionReusableViewItemView";

@implementation UICollectionReusableView (AKNReusableView)

- (void)setItemView:(UIView<AKNViewConfigurable> *)itemView {
    objc_setAssociatedObject(self, &UICollectionReusableViewItemView, itemView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView<AKNViewConfigurable> *)itemView {
    return objc_getAssociatedObject(self, &UICollectionReusableViewItemView);
}

@end
