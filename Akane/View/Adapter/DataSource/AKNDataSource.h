//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@protocol AKNViewModel;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base protocol to provide data to views
 * Insipired by Android Adapters
 * 
 * This protocol is concerned only about data: nothing about views should be inserted into it
 */
@protocol AKNDataSource <NSObject>

@property(nonatomic, strong, nullable)id  items;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (nullable id)supplementaryItemAtSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END