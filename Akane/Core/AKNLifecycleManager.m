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
@property(nonatomic, assign, nonnull)id<AKNPresenter>    presenter;
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

- (void)mount {
    NSNumber *isMounted = objc_getAssociatedObject(self.viewModel, @selector(willMount));

    if (![isMounted boolValue] && [self.viewModel respondsToSelector:@selector(willMount)]) {
        [self.viewModel willMount];
        objc_setAssociatedObject(self.viewModel, @selector(willMount), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)unmount {
    if ([self.viewModel respondsToSelector:@selector(willUnmount)]) {
        [self.viewModel willUnmount];
    }
}

#pragma mark - View Component delegate

- (void)viewComponent:(nonnull UIView<AKNViewComponent> *)view isBindedTo:(nullable id<AKNViewModel>)viewModel {
    NSAssert(!view.window || [view isDescendantOfView:[self view]],
             @"View component is %@ is not a descendant of view %@", view, [self view]);
    
    AKNViewPresenterHolder *holder = objc_getAssociatedObject(view, @selector(presenter));
    id<AKNPresenter> viewPresenter = holder.viewPresenter;
    
    if (!viewPresenter) {
        Class presenterClass = [self presenterClassForViewComponent:view] ?: AKNPresenterViewController.class;
        
        viewPresenter = [[presenterClass alloc] initWithView:view];
        AKNViewPresenterHolder *holder = [[AKNViewPresenterHolder alloc] initWithPresenter:viewPresenter];
        
        objc_setAssociatedObject(view, @selector(presenter), holder, OBJC_ASSOCIATION_RETAIN);
        [self.presenter addPresenter:viewPresenter withViewModel:viewModel];
    }
    
    [viewPresenter setupWithViewModel:viewModel];
    
}

- (void)viewComponentWillAppear {
    [self mount];
}

#pragma mark - Internal

- (nonnull UIView<AKNViewComponent> *)view {
    return self.presenter.view;
}

- (nullable id<AKNViewModel>)viewModel {
    return self.presenter.viewModel;
}

- (Class)presenterClassForViewComponent:(nonnull UIView<AKNViewComponent> *)view {
    if ([view.class respondsToSelector:@selector(componentPresenterClass)]) {
        return [view.class componentPresenterClass];
    }

    Class class = NSClassFromString([NSStringFromClass(view.class) stringByAppendingString:@"Controller"]);

    return [class conformsToProtocol:@protocol(AKNPresenter)] ? class : nil;
}

@end
