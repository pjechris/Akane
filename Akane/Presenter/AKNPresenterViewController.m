//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNPresenterViewController.h"
#import "AKNViewModel.h"
#import "AKNLifecycleManager.h"
#import <Akane/Akane-Swift.h>

@interface AKNPresenterViewController ()
@property(nonatomic, strong, nullable)id<AKNViewModel>              viewModel;
@property(nonatomic, strong, null_unspecified)AKNLifecycleManager   *lifecycleManager;
@property(nonatomic, assign)BOOL                                    awaken;
@end

@implementation AKNPresenterViewController

@dynamic view;

- (nullable instancetype)initWithView:(nonnull UIView<AKNViewComponent> *)view {
    if (!(self = [super init])) {
        return nil;
    }

    self.view = view;
    [self viewDidLoad];

    return self;
}

- (void)dealloc {
    [self.lifecycleManager detach];
}

- (void)setupWithViewModel:(nullable id<AKNViewModel>)viewModel {
    _viewModel = viewModel;

    if ([self isViewLoaded]) {
        [self setupIfNeeded];
        [self.lifecycleManager bindView];
    }
}

- (void)viewDidLoad {
    NSAssert([self.view conformsToProtocol:@protocol(AKNViewComponent)],
             @"controller '%@' view should be of type AKNViewComponent", self.class);

    [super viewDidLoad];

    if (self.viewModel) {
        [self setupIfNeeded];
        [self.lifecycleManager bindView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lifecycleManager mountOnce];
}

- (void)setupIfNeeded {
    if (!self.awaken) {
        self.lifecycleManager = [[AKNLifecycleManager alloc] initWithPresenter:self];

        [self didAwake];
    }

    self.awaken = YES;
    [self.lifecycleManager attach];
}

- (void)didAwake {
    // Default implementation do nothing
}

- (id<AKNPresenter>)childPresenterForSubview:(UIView<AKNViewComponent> *)view {
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController conformsToProtocol:@protocol(AKNPresenter)]) {
            UIViewController<AKNPresenter> *presenter = (UIViewController<AKNPresenter> *)viewController;

            if (presenter.view == view) {
                return presenter;
            }
        }
    }

    return nil;
}

- (void)addChildPresenter:(nonnull id<AKNPresenter>)presenter {
    if ([presenter isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)presenter;

        if ([self.childViewControllers containsObject:viewController]) {
            [self addChildViewController:viewController];
            [viewController didMoveToParentViewController:self];
        }
    }
}


@end
