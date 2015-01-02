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
@property(nonatomic, assign)BOOL                awaken;
@end

@implementation AKNPresenterViewController

- (void)awakeWithViewModel:(id<AKNViewModel>)viewModel {
    // Too late, view model can't be changed anymore
    if (self.awaken) {
        return;
    }

    self.viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self awake];
}

- (void)awake {
    self.awaken = YES;
    [self didAwake];
}

- (void)didAwake {
    // Default implementation do nothing
}

@end
