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
@property(nonatomic, assign)BOOL                awaken;
@end

@implementation AKNPresenterViewController

- (instancetype)initWithView:(UIView<AKNViewConfigurable> *)view {
    if (!(self = [super init])) {
        return nil;
    }

    self.view = view;
    [self viewDidLoad];

    return self;
}

- (void)dealloc {
    [self.view.lifecycleManager unmount];
}

- (void)setupWithViewModel:(id<AKNViewModel>)viewModel {
    if (_viewModel == viewModel) {
        return;
    }

    NSAssert(viewModel != nil, @"Can't setup with a nil ViewModel!");
    _viewModel = viewModel;

    if ([self isViewLoaded]) {
        [self awake];
        [self.view.lifecycleManager attachToPresenter:self];
    }
}

- (void)viewDidLoad {
    NSAssert([self.view conformsToProtocol:@protocol(AKNViewConfigurable)], @"The viewController's view should be of kind AKNView");

    [super viewDidLoad];

    self.presenters = [NSMutableArray new];
    self.view.lifecycleManager = [AKNLifecycleManager new];

    if (self.viewModel) {
        [self awake];
        [self.view.lifecycleManager attachToPresenter:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view.lifecycleManager mount];
}

- (void)awake {
    if (!self.awaken) {
        [self didAwake];
    }

    self.awaken = YES;
}

- (void)didAwake {
    // Default implementation do nothing
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
