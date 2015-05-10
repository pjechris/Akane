//
// This file is part of Akane
//
// Created by Simone Civetta on 11/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNCollectionViewAdapter.h"
#import "AKNCollectionViewAdapter+Private.h"

#import "AKNViewConfigurable.h"
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNViewCache.h"
#import "AKNItemViewModel.h"
#import "AKNCollectionViewCell.h"
#import "AKNViewHelper.h"
#import "AKNReusableViewHandler.h"
#import "AKNReusableViewDelegate.h"

@interface AKNCollectionViewAdapter () <AKNViewCache>
@property(nonatomic, strong)NSMapTable                  *itemViewModels;
@property(nonatomic, strong)NSMutableDictionary         *reusableViewsContent;
@property(nonatomic, strong)NSMutableDictionary         *reusableViewsHandler;
@property(nonatomic, weak)UICollectionView              *collectionView;
@property(nonatomic, strong)id<AKNReusableViewDelegate> defaultViewDelegate;
@end

@implementation AKNCollectionViewAdapter

- (instancetype)initCluster {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.itemViewModels = [NSMapTable weakToStrongObjectsMapTable];
    self.reusableViewsContent = [NSMutableDictionary new];
    self.reusableViewsHandler = [NSMutableDictionary new];
    self.defaultViewDelegate = [AKNReusableViewDelegate new];
    
    self.viewDelegate = self.defaultViewDelegate;
    
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self.collectionView = collectionView;
    
    self = [self initCluster];
    
    return self;
}

// TODO: implement supplementary collection view views
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
    AKNReusableViewHandler *handler = [self handlerForIdentifier:identifier];
    
    [self.viewDelegate reuseView:cell withViewModel:viewModel atIndexPath:indexPath];
    handler.onReuse ? handler.onReuse(cell, indexPath) : nil;
    
    return cell;
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
    
    NSAssert([cell.itemView conformsToProtocol:@protocol(AKNViewConfigurable)],
             @"Cell.itemView for identifier %@ must conform to AKNViewConfigurable protocol", identifier);
    
    return cell;
}

- (UIView<AKNViewConfigurable> *)dequeueReusableSectionWithIdentifier:(NSString *)identifier forSection:(NSInteger)section {
    UIView<AKNViewConfigurable> *view = [self createReusableViewWithIdentifier:identifier];
    
    return view;
}

- (UIView<AKNViewConfigurable> *)createReusableViewWithIdentifier:(NSString *)identifier {
    id viewType = self.reusableViewsContent[identifier];
    
    return (UIView<AKNViewConfigurable> *)view_instantiate(viewType);
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
}

- (void)registerView:(Class)viewClass supplementaryElementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    identifier = [identifier stringByAppendingString:kind];
    
    self.reusableViewsContent[identifier] = viewClass;
}

#pragma mark - Setters

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (_collectionView == collectionView) {
        return;
    }
    
    _collectionView = collectionView;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

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

@end
