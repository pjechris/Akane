//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AKNViewModel;
@protocol AKNViewConfigurable;
@protocol AKNPresenter;
@class AKNState;

@interface AKNLifecycleManager : NSObject

- (instancetype)initWithPresenter:(id<AKNPresenter>)presenter;

- (void)updateWithState:(AKNState *)state;

- (void)remount;
- (void)unmount;

- (void)updateView:(UIView<AKNViewConfigurable> *)view withViewModel:(id<AKNViewModel>)viewModel;

@end
