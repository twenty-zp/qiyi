//
//  ZPTabBarController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//


#import "ZPTabBarController.h"

#import "MainController.h"
#import "TypeController.h"
#import "MineController.h"
#import "SearchController.h"
#import "ZPNavigationController.h"

@interface ZPTabBarController ()<ZPTabBarDelegate,UINavigationControllerDelegate>
{
    UIView * _contentView;
}
@end

@implementation ZPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tabBar = [[ZPTabBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height -kDockHeight, self.view.frame.size.width, kDockHeight)];
    _tabBar.delegate = self;
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tabBar];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_contentView];

    
    //添加ViewController
    [self addChildController];
    
}

- (void)addChildController
{
    //推荐
    UIViewController * main =  [[MainController alloc]init];
    ZPNavigationController * nav = [[ZPNavigationController alloc]initWithRootViewController:main];
     nav.delegate = self;
    //导航
    main = [[TypeController alloc]init];
    ZPNavigationController * typeNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    typeNav.delegate = self;
    
    //发现
    main = [[SearchController alloc]init];
    ZPNavigationController * searchNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    searchNav.delegate = self;
    //我的
    main = [[MineController alloc]init];
    ZPNavigationController * mineNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    mineNav.delegate = self;
    
    
    [self addChildViewController:nav];
    [self addChildViewController:typeNav];
    [self addChildViewController:searchNav];
    [self addChildViewController:mineNav];
    
    
    [self dock:nil tabChangeFrom:0 to:0];
}
- (void)dock:(ZPTabBar *)tabBar tabChangeFrom:(NSUInteger)from to:(NSUInteger)to
{
    UIViewController * old = self.childViewControllers[from];
    
    [old.view removeFromSuperview];
    
    UIViewController * new = self.childViewControllers[to];
    new.view.frame = _contentView.bounds;
    [_contentView addSubview:new.view];
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.childViewControllers.count ==1) {
        [UIView animateWithDuration:0.5 animations:^{
             _tabBar.transform = CGAffineTransformIdentity;
            CGRect frame = _contentView.frame;
            frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight);
            _contentView.frame = frame;
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
             _tabBar.transform = CGAffineTransformMakeTranslation(0, kDockHeight);
            CGRect frame = _contentView.frame;
            frame.size.height += kDockHeight;
            _contentView.frame = frame;
        }];
    }
}
@end

