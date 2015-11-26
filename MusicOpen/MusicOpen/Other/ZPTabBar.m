//
//  ZPTabBar.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPTabBar.h"
#import "ZPTabBarItem.h"
@implementation ZPTabBar
{
    CGFloat kDockItemW;
    
    ZPTabBarItem *  _selectedItem;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg_p"]];
        // 4.添加选项标签
        [self addTabs];
    }
    return self;
}
#pragma mark 添加选项标签
- (void)addTabs
{
    kDockItemW = self.frame.size.width *1.0/4;
    // 1.团购
    [self addOneTab:@"recommend_p_n" selectedIcon:@"recommend_p_p" index:1];
    
    // 2.地图
    [self addOneTab:@"channel_p_n" selectedIcon:@"channel_p_p" index:2];
    
    // 3.收藏
    [self addOneTab:@"ranking_p_n" selectedIcon:@"ranking_p_p" index:3];
    
    // 4.我的
    [self addOneTab:@"myqiyi_p_n" selectedIcon:@"myqiyi_p_p" index:4];
    
//    // 5.添加标签底部的分隔线
//    UIImageView *divider = [[UIImageView  alloc] init];
//    divider.frame = CGRectMake(0, kDockItemH * 5, kDockItemW, 2);
//    divider.image = [UIImage imageNamed:@"separator_tabbar_item.png"];
//    [self addSubview:divider];
}
- (void)addOneTab:(NSString *)icon selectedIcon:(NSString *)selectedIcon index:(int)index
{
    ZPTabBarItem *tab = [[ZPTabBarItem alloc] init];
    [tab setIcon:icon selectedIcon:selectedIcon];
    tab.frame = CGRectMake(kDockItemW * (index-1),0, kDockHeight*1.3, kDockHeight);
    [tab addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
    tab.tag = index - 1;
    [self addSubview:tab];
    
    if (index == 1) {
        [self tabClick:tab];
    }
}
#pragma mark 监听tab点击
- (void)tabClick:(ZPTabBarItem *)tab
{
    // 0.通知代理
    if ([_delegate respondsToSelector:@selector(dock:tabChangeFrom:to:)]) {
        [_delegate dock:self tabChangeFrom:_selectedItem.tag to:tab.tag];
    }
    // 1.控制状态
    _selectedItem.enabled = YES;
    tab.enabled = NO;
    _selectedItem = tab;
}

@end
