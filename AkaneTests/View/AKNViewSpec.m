//
// This file is part of Akkane
//
// Created by JC on 04/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Kiwi/Kiwi.h>
#import <UIKit/UIKit.h>
#import "AKNView.h"
#import "AKNViewModel.h"

SPEC_BEGIN(AKNViewSpec)

__block AKNView  *view;

describe(@"with no view model", ^{
    beforeEach(^{
        view = [AKNView new];
    });

    context(@"when setting view model", ^{
        it(@"should call configure", ^{
            [[view should] receive:@selector(configure)];

            view.viewModel = [KWMock mockForProtocol:@protocol(AKNViewModel)];
        });

        it(@"should call configure EACH time", ^{
            [[view should] receive:@selector(configure) andReturn:nil withCount:2];

            view.viewModel = [KWMock mockForProtocol:@protocol(AKNViewModel)];
            view.viewModel = [KWMock mockForProtocol:@protocol(AKNViewModel)];
        });
    });
});

SPEC_END