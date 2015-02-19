//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNPresenterViewController.h"
#import "AKNViewModel.h"

@interface AKNPresenterViewController ()
@property(nonatomic, strong)id<AKNViewModel>    viewModel;
@property(nonatomic, strong)NSMutableArray      *presenters;
@end

@implementation AKNPresenterViewController

@synthesize viewModel = _viewModel;

- (void)setupWithViewModel:(id<AKNViewModel>)viewModel {
    if (self.viewModel) {
        return;
    }

    self.viewModel = viewModel;
    self.viewModel.eventDispatcher = self;

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

    self.view.viewModel = self.viewModel;
}

- (void)didAwake {
    // Default implementation do nothing
}

- (void)setupView:(UIView<AKNViewConfigurable> *)view {
    if ([self isViewLoaded]) {
        return;
    }

    self.view = view;
    [self viewDidLoad];
}

@end
