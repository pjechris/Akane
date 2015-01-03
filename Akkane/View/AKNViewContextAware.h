//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

@protocol AKNViewContext;

/**
 * Provide a view with a context. Context can/should contain:
 * - presenter reference (AKNPresenter)
 * - command objects (not yet available)
 * - presenter subpresenters. Having them allow you to "bind" them to a subview if superview was created from storyboard
 * or Nib
 *
 */
@protocol AKNViewContextAware <NSObject>

/**
 * The view context providing access to the associated viewModel object and commands
 *
 * You should override this property in your custom views with a more specific protocol implementing the commands you
 * need
 */
@property(nonatomic, weak, readonly)id<AKNViewContext>  context;

@end
