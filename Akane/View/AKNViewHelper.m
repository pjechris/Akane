//
// This file is part of Akkane
//
// Created by JC on 23/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#include "AKNViewHelper.h"
#import "AKNPresenterViewController.h"

__attribute__((overloadable)) UIView *view_instantiate(Class viewClass) { return [viewClass new]; };
__attribute__((overloadable)) UIView *view_instantiate(UINib *nib) {
    return [nib instantiateWithOwner:nil options:nil][0];
}

id<AKNPresenter> view_presenter_new(UIView<AKNViewConfigurable> *view) {
    Class presenterClass = NSClassFromString([NSStringFromClass([view class]) stringByAppendingString:@"Controller"]);

    if (presenterClass && [presenterClass conformsToProtocol:@protocol(AKNPresenter)]) {
        return [[presenterClass alloc] initWithView:view];
    }

    return [[AKNPresenterViewController alloc] initWithView:view];
}