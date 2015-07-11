//
// This file is part of Akkane
//
// Created by JC on 04/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <UIKit/UIKit.h>
#import "AKNViewModelAware.h"

@class AKNLifecycleManager;
@protocol AKNViewComponent;
@protocol AKNViewModel;

@protocol AKNViewComponentDelegate <NSObject>

- (void)viewComponent:(UIView<AKNViewComponent> *)component isBindedTo:(id<AKNViewModel>)viewModel;

@end

@protocol AKNViewComponent <AKNViewModelAware>

@property(nonatomic, weak)id<AKNViewModel>                          viewModel;
@property(nonatomic, weak, readonly)id<AKNViewComponentDelegate>    componentDelegate;

/**
 * @brief configure the view with data
 * Default implementation of this method do nothing. Override the method to set bindings, commands and subpresenter
 * views on the view
 *
 * You should not call this method directly
 */
- (void)configure;

@optional
/// It should call `component:isBindedTo:` delegate method
- (void)bind:(id<AKNViewModel>)viewModel;

@end