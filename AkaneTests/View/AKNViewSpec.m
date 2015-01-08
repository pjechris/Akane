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
#import "AKNViewContext.h"

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

describe(@"with context", ^{
    __block NSObject<AKNViewContext>    *viewContext;

    beforeEach(^{
        view = [AKNView new];
        viewContext = [KWMock mockForProtocol:@protocol(AKNViewContext)];

        view.context = viewContext;
    });

    specify(^{
        [[viewContext shouldNot] beNil];
    });

    context(@"when binding context", ^{
        __block NSObject<AKNViewContext>    *bindingContext;

        beforeEach(^{
            bindingContext = [KWMock mockForProtocol:@protocol(AKNViewContext)];
        });

        context(@"when subview is not a view subview", ^{
            it(@"should do nothing if binding view is not a descendant", ^{
                [[bindingContext shouldNot] receive:@selector(setupView:)];

                [view bindContext:bindingContext to:[UIView nullMock]];
            });
        });

        context(@"when subview is a view subview", ^{
            __block UIView<AKNViewContextAware> *subview;

            beforeEach(^{
                subview = [AKNView new];
                [view addSubview:subview];
            });

            it(@"should setup view and notify parent", ^{
                NSObject *parentContext = (NSObject *)view.context;

                [[bindingContext should] receive:@selector(setupView:)];
                [[parentContext should] receive:@selector(didSetupContext:)];

                [view bindContext:bindingContext to:subview];
            });
        });
    });
});

SPEC_END