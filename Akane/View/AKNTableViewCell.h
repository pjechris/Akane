//
// This file is part of Akkane
//
// Created by JC on 07/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNViewConfigurable.h"

@interface AKNTableViewCell : UITableViewCell

/// the real cell content view
/// this view is directly added to `contentView`
@property(nonatomic, strong)UIView<AKNViewConfigurable> *aknContentView;

- (void)attachViewModel:(id<AKNViewModel>)viewModel;

@end
