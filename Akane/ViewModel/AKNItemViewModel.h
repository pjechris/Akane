//
// This file is part of Akane
//
// Created by JC on 15/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNViewModel.h"

/**
 * View model representing an item
 * Item come with default commands to execute on it
 */
@protocol AKNItemViewModel <AKNViewModel>

@optional

// TODO: Transform this into a Command
@property(nonatomic, assign, readonly)BOOL  canSelect;

// TODO: Transform this into a Command
- (void)selectItem;

@end