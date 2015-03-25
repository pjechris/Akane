//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class AKNReusableViewHandler;

typedef void(^AKNReusableViewRegisterHandle)(AKNReusableViewHandler *handler);

/**
 * Generic protocol that allow you to register both classes and nibs as reusable views
 *
 * Method names are similar to those used by Collection and Table views, with slightly differences that should
 * ease their use
 */
@protocol AKNViewCache <NSObject>

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier;
- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier handle:(AKNReusableViewRegisterHandle)handle;
- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier;
- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier handle:(AKNReusableViewRegisterHandle)handle;

- (void)registerView:(Class)viewClass supplementaryElementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
- (void)registerNibName:(NSString *)nibName supplementaryElementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

@end