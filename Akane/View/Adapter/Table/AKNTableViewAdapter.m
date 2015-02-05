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

@interface AKNTableViewAdapter ()
@property(nonatomic, strong)NSMutableDictionary *sectionModels;
@property(nonatomic, strong)NSMutableDictionary *indexPathModels;

@property(nonatomic, strong)id<AKNItemAdapter>          itemAdapter;
@property(nonatomic, strong)id<AKNItemViewProvider>     itemViewProvider;
@end

@implementation AKNTableViewAdapter

- (instancetype)initWithItemAdapter:(id<AKNItemAdapter>)itemAdapter viewProvider:(id<AKNItemViewProvider>)viewProvider {
    if (!(self = [super init])) {
        return nil;
    }

    self.sectionModels = [NSMutableDictionary new];
    self.indexPathModels = [NSMutableDictionary new];

    self.itemViewProvider = viewProvider;
    self.itemAdapter = itemAdapter;

    return self;
}

- (id<AKNViewModel>)sectionModel:(NSInteger)section {
    id<AKNViewModel> model = self.sectionModels[@(section)];

    if (!model) {
        self.sectionModels[@(section)] = [self.itemAdapter itemAtSection:section];
    }

    return model;
}

- (id<AKNViewModel>)indexPathModel:(NSIndexPath *)indexPath {
    id<AKNViewModel> model = self.indexPathModels[indexPath];

    if (!model) {
        self.indexPathModels[indexPath] = [self.itemAdapter itemAtIndexPath:indexPath];
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
    NSString *identifier = [self.itemViewProvider itemViewIdentifier:viewModel];
    UITableViewCell<AKNViewConfigurable> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.viewModel = viewModel;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}

@end
