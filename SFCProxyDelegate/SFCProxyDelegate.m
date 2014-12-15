//
//  SFCProxyDelegate.m
//  SFCProxyDelegate
//
//  Created by bubnovslavik@gmail.com on 13.11.13.
//  Copyright (c) 2013 bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCProxyDelegate.h"


@interface SFCProxyDelegate ()

@property (weak, nonatomic) id weakDelegate;
@property (weak, nonatomic) id weakDefaultDelegate;
@property (assign, nonatomic, getter = isWhiteList) BOOL whiteList;
@property (strong, nonatomic) NSArray *selectors;

@end


@implementation SFCProxyDelegate

+ (instancetype)proxyDelegate:(id)defaultDelegate withDelegate:(id)delegate {
   SFCProxyDelegate *proxy = [self alloc];
   proxy.weakDelegate = delegate;
   proxy.weakDefaultDelegate = defaultDelegate;
   return proxy;
}


- (id)delegate {
   return self.weakDelegate;
}


- (id)defaultDelegate {
   return self.weakDefaultDelegate;
}


- (NSString *)description {
   return [NSString stringWithFormat:@"<%@ %p '<%@ %p>' is a proxy for '<%@ %p>'. Forward all: %@. %@: %@>",
           [self class],
           self,
           [self.delegate class],
           self.delegate,
           [self.defaultDelegate class],
           self.defaultDelegate,
           self.shouldForwardAllMethods ? @"YES" : @"NO",
           self.selectors ? (self.isWhiteList ? @"White list" : @"Black list") : @"Selectors",
           self.selectors];
}


- (BOOL)respondsToSelector:(SEL)selector {
   return [self.delegate respondsToSelector:selector] || [self.defaultDelegate respondsToSelector:selector];
}


- (void)forwardInvocation:(NSInvocation *)invocation {
   BOOL delegateRespondsToSelector = [self.delegate respondsToSelector:invocation.selector];
   if (delegateRespondsToSelector) {
      [invocation invokeWithTarget:self.delegate];
   }
   
   if ( ! delegateRespondsToSelector || [self shouldForwardMethodWithSelector:invocation.selector]) {
      if ([self.defaultDelegate respondsToSelector:invocation.selector]) {
         [invocation invokeWithTarget:self.defaultDelegate];
      }
   }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
   return [(id)self.delegate methodSignatureForSelector:sel] ? : [(id)self.defaultDelegate methodSignatureForSelector:sel];
}


- (void)setMethodsToForward:(NSArray *)methods {
   @synchronized(self) {
      self.whiteList = YES;
      self.selectors = methods;
   }
}


- (void)setMethodsToNotForward:(NSArray *)methods {
   @synchronized(self) {
      self.whiteList = NO;
      self.selectors = methods;
   }
}


- (BOOL)shouldForwardMethodWithSelector:(SEL)selector {
   if (self.shouldForwardAllMethods) {
      return YES;
   }
   
   if ( ! self.selectors || ! [self.selectors count]) {
      return NO;
   }
   
   BOOL isSelectorInList = [self.selectors containsObject:NSStringFromSelector(selector)];
   BOOL shouldForwardSelector = self.isWhiteList ? isSelectorInList : ! isSelectorInList;
   return shouldForwardSelector;
}

@end
