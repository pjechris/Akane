//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import "AKNCollectionViewAdapter.h"

@class AKNCollectionViewCell;
@class AKNReusableViewHandler;
@protocol AKNItemViewModel;
@protocol AKNViewConfigurable;

@interface AKNCollectionViewAdapter (Private)

- (void)customInit;

- (id<AKNItemViewModel>)sectionModel:(NSInteger)section;
- (id<AKNItemViewModel>)indexPathModel:(NSIndexPath *)indexPath;

- (NSString *)identifierForViewModel:(id<AKNItemViewModel>)viewModel inSection:(NSInteger)section;

- (UICollectionViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableViewOfKind:(NSString *)kind withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (UIView<AKNViewConfigurable> *)createReusableViewWithIdentifier:(NSString *)identifier;
- (AKNReusableViewHandler *)handlerForIdentifier:(NSString *)identifier;

@end
