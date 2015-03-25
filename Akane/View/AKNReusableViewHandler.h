//
// This file is part of Akane
//
// Created by JC on 23/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@protocol AKNReusableView;
@protocol AKNViewModel;
@protocol AKNViewConfigurable;

typedef void(^AKNReusableViewOnReuse)(id<AKNReusableView> reusableView, id<AKNViewConfigurable> itemView, NSIndexPath *indexPath);

@interface AKNReusableViewHandler : NSObject

@property(nonatomic, copy)AKNReusableViewOnReuse    onReuse;

@end
