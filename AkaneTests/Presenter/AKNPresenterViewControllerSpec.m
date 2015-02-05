//
// This file is part of Akkane
//
// Created by JC on 04/01/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Kiwi/Kiwi.h>
#import "AKNPresenterViewController.h"

SPEC_BEGIN(AKNPresenterViewControllerSpec)

__block AKNPresenterViewController *viewController;

beforeEach(^{
    viewController = [AKNPresenterViewController new];
});

describe(@"when setting view model", ^{
    context(@"with view loaded", ^{
        [viewController stub:@selector(isViewLoaded) andReturn:theValue(YES)];

        [[viewController should] receive:@selector(didAwake)];

        [viewController setupWithViewModel:[KWMock nullMockForProtocol:@protocol(AKNViewModel)]];
    });

    context(@"with view NOT loaded", ^{

    });
});

describe(@"when awaken", ^{
    __block id<AKNViewModel> viewModel;

    beforeEach(^{
        viewModel = [KWMock nullMockForProtocol:@protocol(AKNViewModel)];
        [viewController setupWithViewModel:viewModel];
    });

    specify(^{
        [[theValue(viewController.viewModel) shouldNot] beNil];
    });
});

SPEC_END