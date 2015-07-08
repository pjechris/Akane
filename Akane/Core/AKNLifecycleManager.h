//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewConfigurable.h"

@protocol AKNViewModel;
@protocol AKNPresenter;

@interface AKNLifecycleManager : NSObject<AKNViewComponentDelegate>

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithPresenter:(id<AKNPresenter>)presenter;

- (void)mount;
- (void)unmount;

- (void)bindView;

@end
