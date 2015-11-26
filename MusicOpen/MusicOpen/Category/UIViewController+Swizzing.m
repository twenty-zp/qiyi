//
//  UIViewController+Swizzing.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "UIViewController+Swizzing.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzing)



void swizzledMethod(Class class,SEL originalSelector,SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
+ (void)load
{
    swizzledMethod([self class], @selector(viewWillAppear:), @selector(swizzing_viewWillAppear:));
    swizzledMethod([self class], @selector(viewWillDisappear:), @selector(swizzing_ViewWillDisAppear:));
}
- (void)swizzing_viewWillAppear:(BOOL)animated
{
    [self swizzing_viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1 ) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }else
    {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;

}
- (void)swizzing_ViewWillDisAppear:(BOOL)animated
{
    [self swizzing_ViewWillDisAppear:animated];
    if (self.navigationController.viewControllers.count == 1 ) {
        self.navigationController.navigationBarHidden = NO;
    }
}
@end
