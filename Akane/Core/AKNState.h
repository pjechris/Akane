//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <UIKit/UIKit.h>

@protocol AKNViewConfigurable;
@protocol AKNViewModel;
@protocol AKNPresenter;
@class AKNLifecycleManager;

@interface AKNState : NSObject

@property(nonatomic, weak, readonly)id<AKNViewModel>    viewModel;
@property(nonatomic, strong, readonly)id                context;

- (instancetype)initWithViewModel:(id<AKNViewModel>)viewModel context:(id)context;

@end
