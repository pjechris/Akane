//
// This file is part of Akkane
//
// Created by JC on 04/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <UIKit/UIKit.h>
#import "AKNViewModelAware.h"

@protocol AKNViewComponent;
@protocol AKNViewModel;
@protocol AKNPresenter;

NS_ASSUME_NONNULL_BEGIN

@protocol AKNViewComponentDelegate <NSObject>

- (void)viewComponent:(UIView<AKNViewComponent> *)component isBindedTo:(nullable id<AKNViewModel>)viewModel;

@optional
- (void)viewComponentWillAppear;

@end

@protocol AKNViewComponent

@property(nonatomic, weak, nullable)id<AKNViewComponentDelegate>          componentDelegate;

@optional

- (void)bind:(nullable id<AKNViewModel>)viewModel;

/// @return AKNPresenter class
+ (nonnull Class)componentPresenterClass;

@end

NS_ASSUME_NONNULL_END