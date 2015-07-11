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

@interface AKNPresenterViewController : UIViewController<AKNPresenter>

@property(nonatomic, strong, readonly)id<AKNViewModel>      viewModel;
@property(nonatomic, strong)UIView<AKNViewComponent>     *view;

/**
 * @see AKNPresenter
 * Default implementation do nothing
 */
- (void)didAwake;

@end
