//
// This file is part of Akkane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

@protocol AKNViewModel;

/**
 * A presenter is a class which contain components to present a scene on screen:
 * - a view model which represent logic data about the scene
 * - a view which is the scene using UIKit elements
 */
@protocol AKNPresenter <NSObject>

@property(nonatomic, strong, readonly)id<AKNViewModel>  viewModel;
@property(nonatomic, strong, readonly)UIView            *view;

/**
 * This method should be called to set the view model to the presenter
 * (name inspired by awakeWithContext: from WatchKit)
 */
- (void)awakeWithViewModel:(id)viewModel;

@end