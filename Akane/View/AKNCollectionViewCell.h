//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewComponent.h"
#import "UICollectionViewCell+AKNReusableView.h"

@interface AKNCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)IBOutlet UIView<AKNViewComponent>    *itemView;

+ (instancetype)cellWithItemView:(UIView<AKNViewComponent> *)itemView;

@end
