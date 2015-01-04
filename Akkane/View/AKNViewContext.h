//
// This file is part of Akkane
//
// Created by JC on 02/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNViewModelAware.h"

@protocol AKNViewContextAware;

/**
 * Context can/should contain:
 * - view model (AKNViewModelAware)
 * - command objects (not yet available)
 * - subcontexts
 *
 * You'll usually use a AKNPresenter as a view context but having 2 differents protocols allow you to distinguish them
 * if necessary
 */
@protocol AKNViewContext <AKNViewModelAware>

/// the context associated view
@property(nonatomic, strong, readonly)UIView<AKNViewContextAware>    *view;

- (void)setupView:(UIView<AKNViewContextAware> *)view;
- (void)didSetupContext:(id<AKNViewContext>)context;

@end


