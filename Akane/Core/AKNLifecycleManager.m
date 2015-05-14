//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNLifecycleManager.h"
#import "AKNViewConfigurable.h"
#import "AKNViewModel.h"
#import "AKNState.h"
#import "AKNPresenter.h"
#import "AKNPresenterViewController.h"
#import "AKNViewHelper.h"
#import <objc/objc-runtime.h>

@interface AKNLifecycleManager ()
@property(nonatomic, weak)id<AKNPresenter>    presenter;

- (UIView<AKNViewConfigurable> *)view;
- (id<AKNViewModel>)viewModel;
@end

@implementation AKNLifecycleManager

- (void)attachToPresenter:(id<AKNPresenter>)presenter {
    self.presenter = presenter;

    // FIXME: BC to remove
    [self.view setViewModel:presenter.viewModel];
    
    [self.view configure];
}

- (void)mount {
    NSNumber *isMounted = objc_getAssociatedObject(self.viewModel, @selector(willMount));

    if (![isMounted boolValue] && [self.viewModel respondsToSelector:@selector(willMount)]) {
        [self.viewModel willMount];
        objc_setAssociatedObject(self.viewModel, @selector(willMount), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)unmount {
    if ([self.viewModel respondsToSelector:@selector(willUnmount)]) {
        [self.viewModel willUnmount];
    }
}

- (void)updateView:(UIView<AKNViewConfigurable> *)view withViewModel:(id<AKNViewModel>)viewModel {
    NSAssert(!view.window || [view isDescendantOfView:[self view]],
             @"Attempting to call updateView: with a view which is not a subview of current one (%@)", [self view]);

    id<AKNPresenter> presenter = objc_getAssociatedObject(view, @selector(presenter));

    if (!presenter) {
        presenter = view_presenter_new(view);

        objc_setAssociatedObject(view, @selector(presenter), presenter, OBJC_ASSOCIATION_ASSIGN);
    }

    [presenter setupWithViewModel:viewModel];
    [self.presenter presenter:presenter didAcquireViewModel:viewModel];
}

#pragma mark - Internal

- (UIView<AKNViewConfigurable> *)view {
    return self.presenter.view;
}

- (id<AKNViewModel>)viewModel {
    return self.presenter.viewModel;
}

@end
