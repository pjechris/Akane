//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AKNItemViewModel;
@protocol AKNViewCache;

/**
 * Provide reusable views and view models
 *
 */
@protocol AKNItemViewModelProvider <NSObject>

/**
 * Register reusable views on a view cacher (typically, a AKNTableViewAdapter or AKNCollectionViewAdapter)
 * @see :AKNItemViewCacher protocol for more information on it
 */
- (void)registerViews:(id<AKNViewCache>)viewCacher;

/**
 * Return a reusable ViewModel associated to item. You don't have to deal with the reusable part: it will be handled
 * automatically.
 * @param item the item to provide a View Model to
 * @return the item ViewModel. All items should have a ViewModel.
 */
- (id<AKNItemViewModel>)itemViewModel:(id)item;

/**
 * Return the view model view identifier, so that we can load it. You can do checks to determine an identifier
 * depending on the viewModel current "state"
 * @param viewModel the viewModel whose view identifier is requested
 * @return an item identifier
 */
- (NSString *)viewIdentifier:(id<AKNItemViewModel>)viewModel;

/**
 * Return a reusable ViewModel associated to a supplementary item. You don't have to deal with the reusable part: it will be handled
 * automatically.
 * @param item the item to provide a View Model to
 * @return the item ViewModel. All supplementary items should have a ViewModel.
 */
- (id<AKNItemViewModel>)supplementaryItemViewModel:(id)item;

/**
 * Return the view model view identifier, so that we can load it. You can do checks to determine an identifier
 * depending on the viewModel current "state"
 * @param item the viewModel whose view identifier is requested
 * @return an item identifier
 */
@optional
- (NSString *)supplementaryViewIdentifier:(id<AKNItemViewModel>)viewModel;

/**
 * Return a identifier for a static section, that is a section whose not using any item and ViewModel. This method
 * should not be called if `supplementaryViewIdentifier` is implemented
 * @return a identifier registered with `registerView|NibNamed:supplementaryElementKind:`
 */
- (NSString *)supplementaryStaticViewIdentifierForSection:(NSInteger)section;

@end