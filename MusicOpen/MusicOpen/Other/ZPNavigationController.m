//
//  ZPNavigationController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPNavigationController.h"

@implementation ZPNavigationController
+ (void)initialize
{
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"pla_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:20]}];
  
    bar.translucent = NO;
    bar.tintColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
