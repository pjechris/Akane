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

NS_ASSUME_NONNULL_BEGIN

@interface AKNPresenterViewController<ViewModelType: id<AKNViewModel>> : UIViewController<AKNPresenter>

@property(nonatomic, strong, readonly, nullable)ViewModelType       viewModel;
@property(nonatomic, strong)UIView<AKNViewComponent>                *view;

- (void)setupWithViewModel:(nullable ViewModelType)viewModel;


@end

NS_ASSUME_NONNULL_END
