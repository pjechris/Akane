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

@interface AKNTableViewAdapter () <AKNItemViewCacher>
@property(nonatomic, strong)NSMutableDictionary *sectionModels;
@property(nonatomic, strong)NSMutableDictionary *indexPathModels;

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
    return 50;
}

- (void)prepareForUse {
    if (self.contentProvider && self.tableView) {
        [self.contentProvider registerViews:self];
    }
}

#pragma mark - ViewCacher

- (void)registerNibName:(NSString *)nibName withReuseIdentifier:(NSString *)identifier {
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)identifier {
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
