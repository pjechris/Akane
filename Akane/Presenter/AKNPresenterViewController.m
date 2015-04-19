//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNPresenterViewController.h"
#import "AKNViewModel.h"
#import "AKNState.h"
#import "AKNLifecycleManager.h"

@interface AKNPresenterViewController ()
@property(nonatomic, strong)id<AKNViewModel>    viewModel;
@property(nonatomic, strong)NSMutableArray      *presenters;
@property(nonatomic, assign)BOOL                mounted;
@property(nonatomic, assign)BOOL                awaken;
@property(nonatomic, strong)AKNLifecycleManager *lifecycleManager;
@end

@implementation AKNPresenterViewController

@synthesize viewModel = _viewModel;

- (instancetype)initWithView:(UIView<AKNViewConfigurable> *)view {
    if (!(self = [super init])) {
        return nil;
    }

    self.view = view;

    return self;
}

- (void)dealloc {
    if ([self.viewModel respondsToSelector:@selector(willUnmount)]) {
        [self.viewModel willUnmount];
    }
}

- (void)setupWithViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    NSAssert(viewModel != nil, @"Can't setup with a nil ViewModel!");
    _viewModel = viewModel;

    if ([self isViewLoaded] && !self.awaken) {
        [self awake];
    }

    [self updateState];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert([self.view respondsToSelector:@selector(setViewModel:)], @"The viewController's view should be of kind AKNView");

    if (self.viewModel && !self.awaken) {
        [self awake];
    }

    [self updateState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.mounted && [self.viewModel respondsToSelector:@selector(willMount)]) {
        [self.viewModel willMount];
    }

    self.mounted = YES;
}

- (void)awake {
    self.awaken = YES;
    self.presenters = [NSMutableArray new];
    self.lifecycleManager = [[AKNLifecycleManager alloc] initWithPresenter:self];

    [self didAwake];

    self.view.viewModel = self.viewModel;
}

- (void)didAwake {
    // Default implementation do nothing
}

- (void)updateState {
    [self.lifecycleManager updateWithState:[[AKNState alloc] initWithViewModel:self.viewModel context:nil]];
}

- (void)presenter:(id<AKNPresenter>)presenter didAcquireViewModel:(id<AKNViewModel>)viewModel {
    if (![self.presenters containsObject:presenter]) {
        [self.presenters addObject:presenter];

        if ([presenter isKindOfClass:[UIViewController class]] && ![self.childViewControllers containsObject:presenter]) {
            UIViewController *viewController = (UIViewController *)presenter;

            [self addChildViewController:viewController];
            [viewController didMoveToParentViewController:self];
        }
    }
}

@end
