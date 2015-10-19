//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNCollectionViewAdapter.h"

@interface UICollectionView (Adapter)

@property(nonatomic, strong)id<AKNDataSource>             adapterDataSource;

@property(nonatomic, strong)id<AKNItemViewModelProvider>  adapterItemProvider;

@property(nonatomic, strong)AKNCollectionViewAdapter      *adapter;

@end
