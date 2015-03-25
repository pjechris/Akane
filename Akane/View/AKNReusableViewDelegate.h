//
// This file is part of Akane
//
// Created by JC on 25/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@protocol AKNReusableView;
@protocol AKNViewModel;

@protocol AKNReusableViewDelegate <NSObject>

- (void)reuseView:(id<AKNReusableView>)reusableView
    withViewModel:(id<AKNViewModel>)viewModel
      atIndexPath:(NSIndexPath *)indexPath;

@end

@interface AKNReusableViewDelegate : NSObject<AKNReusableViewDelegate>

@end
