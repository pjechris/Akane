//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <UIKit/UIKit.h>
#import "AKNViewModelAware.h"

@protocol AKNViewComponent;
@protocol AKNViewModel;
@class AKNLifecycleManager;
@class AKNScope;

NS_ASSUME_NONNULL_BEGIN

/**
 * Presenter is a context with capabilities to handle "presentation" workflow
 */
@protocol AKNPresenter <AKNViewModelAware>

@property(nonatomic, strong, readonly)UIView<AKNViewComponent>    *view;

- (nullable instancetype)initWithView:(UIView<AKNViewComponent> *)view;

/**
 * This method should be called to set the view model to the presenter BEFORE its view is initialized
 * Once the presenter is awaken, the view model can't be setted anymore
 *
 * @param id viewModel the view model that should be associated to presenter
 */
- (void)setupWithViewModel:(nullable id<AKNViewModel>)viewModel;

/**
 * This method should be called ONCE view is LOADED. didAwake can happen multiple times (if view is unloaded and reloaded
 * for instance)
 *
 * Use this method to configure presenter view with its view model: this is the only where you're sure that both view model
 * and view are loaded
 *
 */
- (void)didAwake;

/// @return the view presenter, if any
- (nullable id<AKNPresenter>)childPresenterForSubview:(UIView<AKNViewComponent> *)view;

- (void)addChildPresenter:(id<AKNPresenter>)presenter;

@end

NS_ASSUME_NONNULL_END