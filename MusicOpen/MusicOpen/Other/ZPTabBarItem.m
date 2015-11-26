//
//  ZPTabBarItem.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPTabBarItem.h"

@implementation ZPTabBarItem
#pragma mark - 设置按钮内部的图片
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}
- (void)setIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    self.icon = icon;
    self.selectedIcon = selectedIcon;
}
- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    [self setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
}

- (void)setSelectedIcon:(NSString *)selectedIcon
{
    _selectedIcon = selectedIcon;
    [self setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateDisabled];
}
@end
