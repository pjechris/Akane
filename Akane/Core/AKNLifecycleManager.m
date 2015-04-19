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
    [[self view] configure];
}

- (void)mountState {

}

- (UIView<AKNViewConfigurable> *)view {
    return self.presenter.view;
}

- (void)updateView:(UIView<AKNViewConfigurable> *)view withViewModel:(id<AKNViewModel>)viewModel {
    NSAssert([view isDescendantOfView:[self view]], @"Attempting to call updateView: with a view which is not a subview of current one (%@)", [self view]);

    id<AKNPresenter> presenter = (!view.lifecycleManager)
    ? [self createPresenterForView:view]
    : view.lifecycleManager.presenter;

    [presenter setupWithViewModel:viewModel];
    [self.presenter presenter:presenter didAcquireViewModel:viewModel];
}

- (id<AKNPresenter>)createPresenterForView:(UIView<AKNViewConfigurable> *)view {
    Class presenterClass = NSClassFromString([NSStringFromClass([view class]) stringByAppendingString:@"Controller"]);

    if (presenterClass && [presenterClass conformsToProtocol:@protocol(AKNPresenter)]) {
        return [[presenterClass alloc] initWithView:view];
    }

    return [[AKNPresenterViewController alloc] initWithView:view];
}

@end
