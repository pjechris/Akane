//
// This file is part of Akane
//
// Created by JC on 30/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@protocol AKNViewModel <NSObject>

@optional
- (void)willMount;
- (void)willUnmount;

@end

@interface AKNViewModel : NSObject<AKNViewModel>

@end
