//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNPresenter.h"
#import "AKNViewComponent.h"

@interface AKNPresenterViewController<ViewModelType: id<AKNViewModel>> : UIViewController<AKNPresenter>

@property(nonatomic, strong, readonly)ViewModelType      viewModel;
@property(nonatomic, strong)UIView<AKNViewComponent>     *view;

- (void)setupWithViewModel:(ViewModelType)viewModel;


@end
