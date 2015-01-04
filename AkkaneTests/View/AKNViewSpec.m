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

SPEC_BEGIN(AKNViewSpec)

__block AKNView  *view;

describe(@"with no context", ^{
    beforeEach(^{
        view = [AKNView new];
    });

    context(@"when setting context", ^{
        it(@"should call configure", ^{
            [[view should] receive:@selector(configure)];

            view.context = [KWMock mockForProtocol:@protocol(AKNViewContext)];
        });

        it(@"should call configure EACH time", ^{
            [[view should] receive:@selector(configure) andReturn:nil withCount:2];

            view.context = [KWMock mockForProtocol:@protocol(AKNViewContext)];
            view.context = [KWMock mockForProtocol:@protocol(AKNViewContext)];
        });
    });
});

SPEC_END