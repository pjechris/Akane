//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNPresenterViewController.h"
#import "AKNViewModel.h"
#import "AKNViewContextAware.h"

@interface AKNPresenterViewController ()
@property(nonatomic, strong)id<AKNViewModel>    viewModel;
@property(nonatomic, strong)NSMutableArray      *presenters;
@end

@implementation AKNPresenterViewController

- (void)awakeWithViewModel:(id<AKNViewModel>)viewModel {
    if (self.viewModel) {
        return;
    }

    self.viewModel = viewModel;

    if ([self isViewLoaded]) {
        [self awake];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.viewModel) {
        [self awake];
    }
}

- (void)awake {
    self.presenters = [NSMutableArray new];

    [self didAwake];

    self.view.context = self;
}

- (void)didAwake {
    // Default implementation do nothing
}

- (void)setupView:(UIView<AKNViewContextAware> *)view {
    if ([self isViewLoaded]) {
        return;
    }

    self.view = view;
    [self viewDidLoad];
}

- (void)didSetupContext:(id<AKNViewContext>)context {
    if ([context isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)context;

        if (viewController.parentViewController && viewController.parentViewController != self) {
            [viewController removeFromParentViewController];
        }

        if (!viewController.parentViewController) {
            [self addChildViewController:viewController];
            [viewController didMoveToParentViewController:self];
        }
    }
}

@end
