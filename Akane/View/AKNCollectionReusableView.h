//
// This file is part of Akane
//
// Created by Pascal Drouilly on 16/09/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UICollectionReusableView+AKNReusableView.h"

@protocol AKNViewComponent;

@interface AKNCollectionReusableView : UICollectionReusableView

@property(nonatomic, strong)IBOutlet UIView<AKNViewComponent>    *itemView;

+ (instancetype)reusableViewWithItemView:(UIView<AKNViewComponent> *)itemView;

@end
