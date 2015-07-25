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

@interface AKNPresenterViewController ()
@property(nonatomic, strong)id<AKNViewModel>    viewModel;
@property(nonatomic, strong)AKNLifecycleManager *lifecycleManager;
@property(nonatomic, assign)BOOL                awaken;
@end

@implementation AKNPresenterViewController

@dynamic view;

- (instancetype)initWithView:(UIView<AKNViewComponent> *)view {
    if (!(self = [super init])) {
        return nil;
    }

    self.view = view;
    [self viewDidLoad];

    return self;
}

- (void)dealloc {
    [self.lifecycleManager unmount];
}

- (void)setupWithViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    _viewModel = viewModel;

    if ([self isViewLoaded]) {
        [self prepare];
    }
}

- (void)viewDidLoad {
    NSAssert([self.view conformsToProtocol:@protocol(AKNViewComponent)], @"The viewController's view should be of kind AKNView");

    [super viewDidLoad];

    if (self.viewModel) {
        [self prepare];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lifecycleManager mount];
}

- (void)prepare {
    if (!self.awaken) {
        self.lifecycleManager = [[AKNLifecycleManager alloc] initWithPresenter:self];

        [self didAwake];
    }

    self.awaken = YES;
    [self.lifecycleManager bindView];
}

- (void)didAwake {
    // Default implementation do nothing
}

- (id<AKNPresenter>)presenterForViewModel:(id<AKNViewModel>)viewModel {
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController conformsToProtocol:@protocol(AKNPresenter)]) {
            UIViewController<AKNPresenter> *presenter = (UIViewController<AKNPresenter> *)viewController;

            if (presenter.viewModel == viewModel) {
                return presenter;
            }
        }
    }

    return nil;
}

- (void)addPresenter:(id<AKNPresenter>)presenter withViewModel:(id<AKNViewModel>)viewModel {
    if ([presenter isKindOfClass:[UIViewController class]] && ![self.childViewControllers containsObject:presenter]) {
        UIViewController *viewController = (UIViewController *)presenter;

        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
}

@end
