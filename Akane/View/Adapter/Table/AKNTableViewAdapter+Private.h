//
// This file is part of Akane
//
// Created by JC on 22/03/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class AKNTableViewCell;
@protocol AKNItemViewModel;
@protocol AKNViewConfigurable;

@interface AKNTableViewAdapter (Private)

- (instancetype)initCluster;

- (id<AKNItemViewModel>)sectionModel:(NSInteger)section;
- (id<AKNItemViewModel>)indexPathModel:(NSIndexPath *)indexPath;

- (AKNTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (UIView<AKNViewConfigurable> *)dequeueReusableSectionWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;

- (void)cellContentView:(AKNTableViewCell *)cell withIdentifier:(NSString *)identifier;
- (UIView<AKNViewConfigurable> *)createReusableViewWithIdentifier:(NSString *)identifier;

@end
