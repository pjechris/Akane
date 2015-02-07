//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

/**
 * Generic protocol that allow you to register both classes and nibs as reusable views
 *
 * Method names are similar to those used by Collection and Table views, with slightly differences that should
 * ease their use
 */
@protocol AKNItemViewCacher <NSObject>

- (void)registerItemView:(Class)viewClass withReuseIdentifier:(NSString *)identifier;
- (void)registerItemNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier;

- (void)registerSupplementaryView:(Class)viewClass elementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
- (void)registerSupplementaryNibName:(NSString *)nibName elementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

@end