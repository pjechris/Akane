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
#import "AKNViewConfigurable.h"

@interface AKNPresenterViewController : UIViewController<AKNPresenter>

/**
 * @see AKNPresenter
 * Default implementation do nothing
 */
- (void)didAwake;

@end
