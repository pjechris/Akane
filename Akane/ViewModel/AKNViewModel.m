//
// This file is part of Akane
//
// Created by JC on 15/02/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "AKNViewModel.h"

@implementation AKNViewModel

- (void)addEventListener:(NSString *)type listener:(SEL)selector {
    [self.eventDispatcher addEventListener:type listener:selector];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
    [self.eventDispatcher addEventListener:type listener:selector useCapture:useCapture];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
    [self.eventDispatcher addEventListener:type listener:selector useCapture:useCapture priority:priority];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture {
    [self.eventDispatcher addEventListener:type block:block useCapture:useCapture];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
    [self.eventDispatcher addEventListener:type block:block useCapture:useCapture priority:priority];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector {
    [self.eventDispatcher addEventListener:type listener:selector];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
    [self.eventDispatcher removeEventListener:type listener:selector useCapture:useCapture];
}

- (void)removeEventListener:(NSString *)type useCapture:(BOOL)capture {
    [self.eventDispatcher removeEventListener:type useCapture:capture];
}

- (void)dispatchEvent:(EVEEvent *)event {
    [self.eventDispatcher dispatchEvent:event];
}

- (id<EVEEventDispatcher>)nextDispatcher {
    return nil;
}

@end
