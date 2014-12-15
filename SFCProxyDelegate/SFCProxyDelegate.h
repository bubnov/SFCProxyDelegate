//
//  SFCProxyDelegate.h
//  SFCProxyDelegate
//
//  Created by bubnovslavik@gmail.com on 13.11.13.
//  Copyright (c) 2013 bubnovslavik@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Proxy delegate
 
 @discussion Usually, default delegate implements protocol methods with default logic, when proxy-delegate can optionally override them.
 @discussion If delegate implements method - its methods will be called. If not - proxy will check default delegate and try to call same method on it. If method was called on delegate, same method of default delegate will not be called.
 @discussion Sometimes it is usefull to call default logic. To forward all methods to default delegate, set 'shouldForwardAllMethods' flag to YES. To manage which methods should be forwarded use -setMethodsToForward: and -setMethodsToNotForward: alternative methods.
 */
@interface SFCProxyDelegate : NSProxy

/**
 Delegate, that is a proxy for self.defaultDelegate
 */
@property (readonly, nonatomic) id delegate;

/**
 Delegate, that is proxied by self.delegate
 */
@property (readonly, nonatomic) id defaultDelegate;

/**
 If YES - all methods will be forwarded to the default delegate. Default value is NO.
 */
@property (assign, nonatomic) BOOL shouldForwardAllMethods;

/**
 Designated initializer
 @param defaultDelegate Delegate, that should be proxied
 @param delegate Delegate, that is a proxy for default delegate
 @return SFCProxyDelegate
 */
+ (instancetype)proxyDelegate:(id)defaultDelegate withDelegate:(id)delegate;

/**
 Will forward only this methods to default delegate ('white list' of methods)
 @param methods Array of methods names
 @code
 [proxyDelegate setMethodsToForward:@[
   @"delegateMethodWithArg1:arg2:", 
   ...
 ]];
 @endcode
 */
- (void)setMethodsToForward:(NSArray *)methods;

/**
 Will forward all methods, except this methods ('black list' of methods)
 @param methods Array of methods names
 @code
 [proxyDelegate setMethodsToNotForward:@[
   @"delegateMethodWithArg1:arg2:",
   ...
 ]];
 */
- (void)setMethodsToNotForward:(NSArray *)methods;

@end
