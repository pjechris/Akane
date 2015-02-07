//
// This file is part of Akane
//
// Created by JC on 05/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNTableViewAdapter.h"
#import "AKNViewConfigurable.h"
#import "AKNItemAdapter.h"
#import "AKNItemViewProvider.h"
#import "AKNItemViewCacher.h"

CGFloat const TableViewAdapterDefaultRowHeight = 44.f;

@interface AKNTableViewAdapter () <AKNItemViewCacher>
@property(nonatomic, strong)NSMutableDictionary *sectionModels;
@property(nonatomic, strong)NSMutableDictionary *indexPathModels;
@property(nonatomic, strong)NSMutableDictionary *reusableViews;
@property(nonatomic, strong)NSMutableDictionary *prototypeViews;

@property(nonatomic, strong)id<AKNItemAdapter>          itemAdapter;
@property(nonatomic, strong)id<AKNItemContentProvider>  contentProvider;
@end

@implementation AKNTableViewAdapter

- (instancetype)initWithItemAdapter:(id<AKNItemAdapter>)itemAdapter content:(id<AKNItemContentProvider>)contentProvider {
    if (!(self = [super init])) {
        return nil;
    }

    self.sectionModels = [NSMutableDictionary new];
    self.indexPathModels = [NSMutableDictionary new];
    self.reusableViews = [NSMutableDictionary new];
    self.prototypeViews = [NSMutableDictionary new];

    self.contentProvider = contentProvider;
    self.itemAdapter = itemAdapter;

    return self;
}

- (id<AKNViewModel>)sectionModel:(NSInteger)section {
    id<AKNViewModel> model = self.sectionModels[@(section)];

    if (!model) {
        id item = [self.itemAdapter supplementaryItemAtSection:section];

        model = [self.contentProvider supplementaryItemViewModel:item];

        self.sectionModels[@(section)] = model;
    }

    return model;
}

- (id<AKNViewModel>)indexPathModel:(NSIndexPath *)indexPath {
    id<AKNViewModel> model = self.indexPathModels[indexPath];

    if (!model) {
        id item = [self.itemAdapter itemAtIndexPath:indexPath];

        model = [self.contentProvider itemViewModel:item];

        self.indexPathModels[indexPath] = model;
    }

    return model;
}

#pragma mark - Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemAdapter numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemAdapter numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.contentProvider viewModelViewIdentifier:viewModel];
    UITableViewCell<AKNViewConfigurable> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.viewModel = viewModel;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AKNViewModel> viewModel = [self indexPathModel:indexPath];
    NSString *identifier = [self.contentProvider viewModelViewIdentifier:viewModel];
    UITableViewCell<AKNViewConfigurable> *cell = [self prototypeViewWithReuseIdentifier:identifier];

    cell.viewModel = viewModel;

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    if (height == 0) {
        NSLog(@"Detected a case where constraints ambiguously suggest a height of zero for a tableview cell's content view.\
              We're considering the collapse unintentional and using %f height instead", TableViewAdapterDefaultRowHeight);

        height = TableViewAdapterDefaultRowHeight;
    }

    return height;
}

- (void)prepareForUse {
    if (self.contentProvider && self.tableView) {
        [self.contentProvider registerViews:self];
    }
}

- (UITableViewCell<AKNViewConfigurable> *)prototypeViewWithReuseIdentifier:(NSString *)identifier {
    UITableViewCell *cell = self.prototypeViews[identifier];

    if (!cell) {
        id reusableView = self.reusableViews[identifier];

        cell = ([reusableView isKindOfClass:[UINib class]])
        ? [reusableView instantiateWithOwner:nil options:nil][0]
        : [reusableView new];
    }

    return cell;
}

#pragma mark - ViewCacher delegate

- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier {
    self.reusableViews[identifier] = [UINib nibWithNibName:nibName bundle:nil];

    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier {
    self.reusableViews[identifier] = viewClass;

    [self.tableView registerClass:viewClass forCellReuseIdentifier:identifier];
}

- (void)registerNibName:(NSString *)nibName elementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    // TODO
}

- (void)registerView:(Class)viewClass elementKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    // TODO
}

#pragma mark - Setters

- (void)setTableView:(UITableView *)tableView {
    if (_tableView == tableView) {
        return;
    }

    _tableView = tableView;

    [self prepareForUse];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)setContentProvider:(id<AKNItemContentProvider>)contentProvider {
    if (_contentProvider == contentProvider) {
        return;
    }

    _contentProvider = contentProvider;
    [self prepareForUse];
    [_tableView reloadRowsAtIndexPaths:[_tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setItemAdapter:(id<AKNItemAdapter>)itemAdapter {
    if (_itemAdapter == itemAdapter) {
        return;
    }

    _itemAdapter = itemAdapter;
    [_tableView reloadData];
}

@end
