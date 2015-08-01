//
// This file is part of Akkane
//
// Created by JC on 02/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewComponent.h"

@protocol AKNViewModel;

@interface AKNView<ViewModelType: id<AKNViewModel>> : UIView<AKNViewComponent>

@property(nonatomic, weak)ViewModelType  viewModel;

/**
 * @brief configure the view with data
 * Default implementation of this method do nothing. Override the method to set bindings, commands and subpresenter
 * views on the view
 *
 * You should not call this method directly
 */
- (void)configure;

- (void)bind:(ViewModelType)viewModel NS_REQUIRES_SUPER;

- (void)bind:(id<AKNViewModel>)viewModel to:(UIView<AKNViewComponent> *)viewComponent NS_REQUIRES_SUPER;

@end