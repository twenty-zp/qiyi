//
//  ZPTabBarItem.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPTabBarItem : UIButton
- (void)setIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon;
@property (nonatomic, copy) NSString *icon; // 普通图片
@property (nonatomic, copy) NSString *selectedIcon; // 选中图片
@end
