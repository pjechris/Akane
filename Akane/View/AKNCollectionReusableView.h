//
// This file is part of Akane
//
// Created by Pascal Drouilly on 16/09/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewConfigurable.h"
#import "UICollectionReusableView+AKNReusableView.h"

@interface AKNCollectionReusableView : UICollectionReusableView

@property(nonatomic, strong)IBOutlet UIView<AKNViewConfigurable>    *itemView;

+ (instancetype)reusableViewWithItemView:(UIView<AKNViewConfigurable> *)itemView;

@end
