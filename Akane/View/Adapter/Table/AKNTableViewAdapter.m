//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewAdapter.h"
#import "AKNTableViewAdapter+Private.h"
#import "AKNViewConfigurable.h"
#import "AKNDataSource.h"
#import "AKNItemViewModelProvider.h"
#import "AKNViewCache.h"
#import "AKNItemViewModel.h"
#import "AKNTableViewCell.h"
#import "AKNTableViewAdapteriOS7.h"
#import "AKNViewHelper.h"
#import "AKNReusableViewHandler.h"

@interface AKNTableViewAdapter () <AKNViewCache>
@property(nonatomic, strong)NSMapTable          *itemViewModels;
@property(nonatomic, strong)NSMutableDictionary *reusableViewsContent;
@property(nonatomic, strong)NSMutableDictionary *reusableViewsHandler;
@property(nonatomic, weak)UITableView           *tableView;

@end

@implementation AKNTableViewAdapter

- (instancetype)initCluster {
    if (!(self = [super init])) {
        return nil;
    }

    self.itemViewModels = [NSMapTable weakToStrongObjectsMapTable];
    self.reusableViewsContent = [NSMutableDictionary new];
    self.reusableViewsHandler = [NSMutableDictionary new];

    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];

    if ([systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        self = [[AKNTableViewAdapteriOS7 alloc] initCluster];
    }
    else {
        self = [self initCluster];
    }

    self.tableView = tableView;

    return self;
}

- (id<AKNItemViewModel>)sectionModel:(NSInteger)section {
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

#pragma mark - Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.dataSource && self.itemViewModelProvider) ? [self.dataSource numberOfSections] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.itemViewModelProvider viewIdentifier:viewModel];
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    AKNReusableViewHandler *handler = [self handlerForIdentifier:identifier];

    [handler reuseView:cell withViewModel:viewModel atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    if (![viewModel respondsToSelector:@selector(canSelect)]) {
        return indexPath;
    }    
    return [viewModel canSelect] ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNItemViewModel> viewModel = [self indexPathModel:indexPath];
    if ([viewModel respondsToSelector:@selector(selectItem)]) {
        [viewModel selectItem];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<AKNItemViewModel> sectionViewModel = [self sectionModel:section];
    NSString *identifier = [self.itemViewModelProvider supplementaryViewIdentifier:sectionViewModel];
    identifier = [identifier stringByAppendingString:UICollectionElementKindSectionHeader];

    if (!identifier) {
        return nil;
    }

    UIView<AKNViewConfigurable> *sectionView = [self dequeueReusableSectionWithIdentifier:identifier forSection:section];
    sectionView.viewModel = sectionViewModel;

    return sectionView;
}

#pragma mark - Internal

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [AKNTableViewCell cellWithItemView:[self createReusableViewWithIdentifier:identifier]];
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
    [self registerNibName:nibName withReuseIdentifier:identifier onReuse:nil];
}

- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier onReuse:(AKNReusableViewOnReuse)onReuse {
    AKNReusableViewHandler *handler = [AKNReusableViewHandler new];

    handler.onReuse = onReuse;

    self.reusableViewsContent[identifier] = [UINib nibWithNibName:nibName bundle:nil];
    self.reusableViewsHandler[identifier] = handler;
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier {
    self.reusableViewsContent[identifier] = viewClass;
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

- (void)setTableView:(UITableView *)tableView {
    if (_tableView == tableView) {
        return;
    }

    _tableView = tableView;

    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)setItemViewModelProvider:(id<AKNItemViewModelProvider>)itemViewModelProvider {
    if (_itemViewModelProvider == itemViewModelProvider) {
        return;
    }

    _itemViewModelProvider = itemViewModelProvider;
    [self.itemViewModelProvider registerViews:self];
    [_tableView reloadData];
}

- (void)setDataSource:(id<AKNDataSource>)dataSource {
    if (_dataSource == dataSource) {
        return;
    }
    
    _dataSource = dataSource;
    [_tableView reloadData];
}

@end
