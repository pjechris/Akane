//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNState.h"

@interface AKNState ()
@property(nonatomic, weak)id<AKNViewModel>    viewModel;
@property(nonatomic, strong)id                context;
@end

@implementation AKNState

- (instancetype)initWithViewModel:(id<AKNViewModel>)viewModel context:(id)context {
    if (!(self = [super init])) {
        return nil;
    }

    self.viewModel = viewModel;
    self.context = context;

    return self;
}

@end
