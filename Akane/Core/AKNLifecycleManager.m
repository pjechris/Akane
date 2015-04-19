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
#import <objc/objc-runtime.h>

@interface AKNLifecycleManager ()
@property(nonatomic, weak)id<AKNPresenter>    presenter;
@property(nonatomic, strong)AKNState            *state;
@end

@implementation AKNLifecycleManager

- (instancetype)initWithPresenter:(id<AKNPresenter>)presenter {
    if (!(self = [super init])) {
        return nil;
    }

    self.presenter = presenter;

    return self;
}

- (void)updateWithState:(AKNState *)state {
    self.state = state;
    // FIXME: BC to remove
    [[self view] setViewModel:state.viewModel];
    
    [[self view] configure];
}

- (void)remount {
    NSNumber *isMounted = objc_getAssociatedObject(self.state.viewModel, @selector(willMount));

    if (![isMounted boolValue] && [self.state.viewModel respondsToSelector:@selector(willMount)]) {
        [self.state.viewModel willMount];
        objc_setAssociatedObject(self.state.viewModel, @selector(willMount), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)unmount {
    if ([self.state.viewModel respondsToSelector:@selector(willUnmount)]) {
        [self.state.viewModel willUnmount];
    }
}

- (void)updateView:(UIView<AKNViewConfigurable> *)view withViewModel:(id<AKNViewModel>)viewModel {
    NSAssert(!view.window || [view isDescendantOfView:[self view]],
             @"Attempting to call updateView: with a view which is not a subview of current one (%@)", [self view]);

    id<AKNPresenter> presenter = (!view.lifecycleManager) ? [self createPresenterForView:view] : view.lifecycleManager.presenter;

    [presenter setupWithViewModel:viewModel];
    [self.presenter presenter:presenter didAcquireViewModel:viewModel];
}

#pragma mark - Internal

- (UIView<AKNViewConfigurable> *)view {
    return self.presenter.view;
}


- (id<AKNPresenter>)createPresenterForView:(UIView<AKNViewConfigurable> *)view {
    Class presenterClass = NSClassFromString([NSStringFromClass([view class]) stringByAppendingString:@"Controller"]);

    if (presenterClass && [presenterClass conformsToProtocol:@protocol(AKNPresenter)]) {
        return [[presenterClass alloc] initWithView:view];
    }

    return [[AKNPresenterViewController alloc] initWithView:view];
}

@end
