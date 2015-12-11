//
// This file is part of Akane
//
// Created by JC on 18/04/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNLifecycleManager.h"
#import "AKNViewModel.h"
#import "AKNPresenter.h"
#import "AKNPresenterViewController.h"
#import "AKNViewHelper.h"
#import <objc/runtime.h>

@interface AKNLifecycleManager ()
- (UIView<AKNViewComponent> *)view;
- (id<AKNViewModel>)viewModel;
@end

@interface AKNViewPresenterHolder : NSObject
@property (weak, nonatomic) id<AKNPresenter> viewPresenter;
@end

@implementation AKNViewPresenterHolder

- (id)initWithPresenter:(id<AKNPresenter>)viewPresenter {
    if (self = [super init]) {
        self.viewPresenter = viewPresenter;
    }
    return self;
}

@end

@implementation AKNLifecycleManager

- (nonnull instancetype)initWithPresenter:(nonnull id<AKNPresenter>)presenter {
    if (!(self = [super init])) {
        return nil;
    }

    self.presenter = presenter;

    return self;
}

- (void)mountOnce {
    NSNumber *isMounted = objc_getAssociatedObject(self.viewModel, @selector(willMount));

    if (![isMounted boolValue] && [self.viewModel respondsToSelector:@selector(willMount)]) {
        [self.viewModel willMount];
        objc_setAssociatedObject(self.viewModel, @selector(willMount), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - View Component delegate

// TODO remove this method
- (void)viewComponent:(nonnull UIView<AKNViewComponent> *)view isBindedTo:(nullable id<AKNViewModel>)viewModel {
    NSAssert(!view.window || [view isDescendantOfView:[self view]],
             @"View component is %@ is not a descendant of view %@", view, [self view]);
    
    AKNViewPresenterHolder *holder = objc_getAssociatedObject(view, @selector(presenter));
    id<AKNPresenter> viewPresenter = holder.viewPresenter;
    
    if (!viewPresenter) {
        Class presenterClass = [view.class componentPresenterClass];
        
        viewPresenter = [[presenterClass alloc] initWithView:view];
        AKNViewPresenterHolder *holder = [[AKNViewPresenterHolder alloc] initWithPresenter:viewPresenter];
        
        objc_setAssociatedObject(view, @selector(presenter), holder, OBJC_ASSOCIATION_RETAIN);
        [self.presenter addChildPresenter:viewPresenter];
    }
    
    [viewPresenter setupWithViewModel:viewModel];
    
}

- (void)viewComponentWillAppear {
    [self mountOnce];
}

#pragma mark - Internal

- (nonnull UIView<AKNViewComponent> *)view {
    return self.presenter.view;
}

- (nullable id<AKNViewModel>)viewModel {
    return self.presenter.viewModel;
}

@end
