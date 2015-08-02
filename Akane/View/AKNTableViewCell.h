//
// This file is part of Akkane
//
// Created by JC on 07/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewComponent.h"
#import "UITableViewCell+AKNReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKNTableViewCell : UITableViewCell

@property(nonatomic, strong, nullable)IBOutlet UIView<AKNViewComponent>    *itemView;

+ (nullable instancetype)cellWithItemView:(UIView<AKNViewComponent> *)itemView;

@end

NS_ASSUME_NONNULL_END
