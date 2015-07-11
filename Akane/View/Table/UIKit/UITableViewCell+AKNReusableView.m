//
// This file is part of Akkane
//
// Created by JC on 22/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UITableViewCell+AKNReusableView.h"
#import <objc/runtime.h>

NSString *UITableViewCellItemView = @"UITableViewCellItemView";

@implementation UITableViewCell (AKNReusableView)

- (void)setItemView:(UIView<AKNViewComponent> *)itemView {
    objc_setAssociatedObject(self, &UITableViewCellItemView, itemView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView<AKNViewComponent> *)itemView {
    return objc_getAssociatedObject(self, &UITableViewCellItemView);
}

@end
