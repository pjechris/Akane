//
// This file is part of Akkane
//
// Created by JC on 02/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@protocol AKNViewModel;

@protocol AKNViewModelAware <NSObject>

@property(nonatomic, strong, readonly)id<AKNViewModel>  viewModel;

@end
