//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AKNViewModel;
@protocol AKNDataSource;
@protocol AKNItemViewModelProvider;
@protocol AKNReusableViewDelegate;

/**
 * Adapter to transpose UICollectionViewDataSource and UICollectionViewDelegate protocols to Adapter protocols
 */
@interface AKNCollectionViewAdapter : NSObject

@property(nonatomic, strong)id<AKNDataSource>               dataSource;
@property(nonatomic, strong)id<AKNItemViewModelProvider>    itemViewModelProvider;
@property(nonatomic, weak, readonly)UICollectionView        *collectionView;
@property(nonatomic, weak)id<AKNReusableViewDelegate>       viewDelegate;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
