//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNCollectionViewAdapter.h"
#import "AKNCollectionViewAdapter+Private.h"

#import "AKNViewComponent.h"
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNViewCache.h"
#import "AKNItemViewModel.h"
#import "AKNCollectionViewCell.h"
#import "AKNCollectionReusableView.h"
#import "AKNViewHelper.h"
#import "AKNReusableViewHandler.h"
#import "AKNLifecycleManager.h"
#import "UICollectionReusableView+AKNReusableView.h"
#import "UICollectionViewCell+AKNReusableView.h"

@interface AKNCollectionViewAdapter () <AKNViewCache, UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)NSMapTable                  *itemViewModels;
@property(nonatomic, strong)NSMutableDictionary         *reusableViewsContent;
@property(nonatomic, strong)NSMutableDictionary         *reusableViewsHandler;
@property(nonatomic, weak)UICollectionView              *collectionView;
@end

@implementation AKNCollectionViewAdapter

- (instancetype)initCluster {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.itemViewModels = [NSMapTable weakToStrongObjectsMapTable];
    self.reusableViewsContent = [NSMutableDictionary new];
    self.reusableViewsHandler = [NSMutableDictionary new];
    
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self.collectionView = collectionView;
    
    self = [self initCluster];
    
    return self;
}

- (id<AKNItemViewModel>)sectionModel:(NSInteger)section {
    if (![self.dataSource respondsToSelector:@selector(supplementaryItemAtSection:)]) {
        return nil;
    }
    
    id item = [self.dataSource supplementaryItemAtSection:section];
    id<AKNItemViewModel> model = [self.itemViewModels objectForKey:item];
    
    if (!model) {
        model = [self.itemViewModelProvider supplementaryItemViewModel:item];
        
        if (model) {
            [self.itemViewModels setObject:model forKey:item];
        }
    }
    
    return model;
}

// Fixme this method is poorly named
- (id<AKNItemViewModel>)indexPathModel:(NSIndexPath *)indexPath {
    id item = [self.dataSource itemAtIndexPath:indexPath];
    id<AKNItemViewModel> model = [self.itemViewModels objectForKey:item];
    
    if (!model) {
        model = [self.itemViewModelProvider itemViewModel:item];
        
        if (model) {
            [self.itemViewModels setObject:model forKey:item];
        }
    }
    
    return model;
}

#pragma mark - Collection delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataSource numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.itemViewModelProvider viewIdentifier:viewModel];
    UICollectionViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    [cell.itemView bind:viewModel];
    [cell setNeedsLayout]; // This fix Self-sizing cell labels not always sized correctly

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.itemViewModelProvider viewIdentifier:viewModel];
    AKNReusableViewHandler *handler = [self handlerForIdentifier:identifier];

    handler.onReuse ? handler.onReuse(cell, indexPath) : nil;
    
    if ([cell.itemView.componentDelegate respondsToSelector:@selector(viewComponentWillAppear)]) {
        [cell.itemView.componentDelegate viewComponentWillAppear];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    if (![viewModel respondsToSelector:@selector(canSelect)]) {
        return YES;
    }
    return [viewModel canSelect];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    if ([viewModel respondsToSelector:@selector(selectItem)]) {
        [viewModel selectItem];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;

    id<AKNItemViewModel> viewModel = [self sectionModel:section];
    NSString *identifier = [self identifierForViewModel:viewModel inSection:section];
    identifier = [identifier stringByAppendingString:UICollectionElementKindSectionHeader];

    if (!identifier) {
        return nil;
    }

    UICollectionReusableView *reusableView = [self dequeueReusableViewOfKind:kind withIdentifier:identifier forIndexPath:indexPath];

    [reusableView.itemView bind:viewModel];
    [reusableView setNeedsLayout]; // This fix Self-sizing view labels not always sized correctly

    return reusableView;
}

#pragma mark - Internal

- (NSString *)identifierForViewModel:(id<AKNItemViewModel>)viewModel inSection:(NSInteger)section {
    if ([self.itemViewModelProvider respondsToSelector:@selector(supplementaryViewIdentifier:)]) {
        return [self.itemViewModelProvider supplementaryViewIdentifier:viewModel];
    }
    
    if ([self.itemViewModelProvider respondsToSelector:@selector(supplementaryStaticViewIdentifierForSection:)]) {
        return [self.itemViewModelProvider supplementaryStaticViewIdentifierForSection:section];
    }
    
    return nil;
}

- (UICollectionViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell.itemView) {
        cell.itemView = [self createReusableViewWithIdentifier:identifier];
    }
    
    NSAssert([cell.itemView conformsToProtocol:@protocol(AKNViewComponent)],
             @"Cell.itemView for identifier %@ must conform to AKNViewComponent protocol", identifier);
    
    return cell;
}

- (UICollectionReusableView *)dequeueReusableViewOfKind:(NSString *)kind withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];

    if (!reusableView.itemView) {
        reusableView.itemView = [self createReusableViewWithIdentifier:identifier];
    }

    NSAssert([reusableView.itemView conformsToProtocol:@protocol(AKNViewComponent)],
            @"reusableView.itemView for identifier %@ must conform to AKNViewComponent protocol", identifier);

    return reusableView;
}

- (UIView<AKNViewComponent> *)createReusableViewWithIdentifier:(NSString *)identifier {
    id viewType = self.reusableViewsContent[identifier];
    
    return (UIView<AKNViewComponent> *)view_instantiate(viewType);
}

- (AKNReusableViewHandler *)handlerForIdentifier:(NSString *)identifier {
    return self.reusableViewsHandler[identifier];
}

#pragma mark - ViewCacher delegate

- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier {
    [self registerNibName:nibName withReuseIdentifier:identifier handle:nil];
}

- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier handle:(AKNReusableViewRegisterHandle)handle {
    self.reusableViewsContent[identifier] = [UINib nibWithNibName:nibName bundle:nil];

    [self.collectionView registerClass:[AKNCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self registerHandlerForReuseIdentifier:identifier onRegistered:handle];
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier {
    [self registerView:viewClass withReuseIdentifier:identifier handle:nil];
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier handle:(AKNReusableViewRegisterHandle)handle {
    self.reusableViewsContent[identifier] = viewClass;

    [self.collectionView registerClass:[AKNCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self registerHandlerForReuseIdentifier:identifier onRegistered:handle];
}

- (void)registerHandlerForReuseIdentifier:(NSString *)identifier onRegistered:(AKNReusableViewRegisterHandle)handle {
    AKNReusableViewHandler *handler = [AKNReusableViewHandler new];
    
    self.reusableViewsHandler[identifier] = handler;
    
    handle ? handle(handler) : nil;
}

- (void)registerNibName:(NSString *)nibName supplementaryElementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    identifier = [identifier stringByAppendingString:kind];
    self.reusableViewsContent[identifier] = [UINib nibWithNibName:nibName bundle:nil];

    [self.collectionView registerClass:[AKNCollectionReusableView class] forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)registerView:(Class)viewClass supplementaryElementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    identifier = [identifier stringByAppendingString:kind];
    self.reusableViewsContent[identifier] = viewClass;

    [self.collectionView registerClass:[AKNCollectionReusableView class] forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

#pragma mark - Setters

- (void)setItemViewModelProvider:(id<AKNItemViewModelProvider>)itemViewModelProvider {
    if (_itemViewModelProvider == itemViewModelProvider) {
        return;
    }
    
    _itemViewModelProvider = itemViewModelProvider;
    
    if ([self.itemViewModelProvider respondsToSelector:@selector(registerViews:)]) {
        [self.itemViewModelProvider registerViews:self];
    }
    [_collectionView reloadData];
}

- (void)setDataSource:(id<AKNDataSource>)dataSource {
    if (_dataSource == dataSource) {
        return;
    }
    
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (collectionView == _collectionView) {
        return;
    }

    _collectionView = collectionView;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

@end
