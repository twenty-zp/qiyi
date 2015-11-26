//
//  ZPTabBar.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPTabBarDelegate;
@interface ZPTabBar : UIView

@property (nonatomic,assign)id<ZPTabBarDelegate> delegate;
@end

@protocol ZPTabBarDelegate <NSObject>

- (void)dock:(ZPTabBar *)tabBar tabChangeFrom:(NSUInteger )from to:(NSUInteger)to;

@end