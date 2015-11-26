//
//  TabBarController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/4.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "TabBarController.h"
#import "RDVTabBarItem.h"

#import "MainController.h"
#import "TypeController.h"
#import "MineController.h"
#import "SearchController.h"

#import "ZPNavigationController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    //推荐
    UIViewController * main =  [[MainController alloc]init];
    ZPNavigationController * nav = [[ZPNavigationController alloc]initWithRootViewController:main];
    
    //导航
    main = [[TypeController alloc]init];
    ZPNavigationController * typeNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    
    
    //发现
    main = [[SearchController alloc]init];
    ZPNavigationController * searchNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    //我的
    main = [[MineController alloc]init];
    ZPNavigationController * mineNav = [[ZPNavigationController alloc]initWithRootViewController:main];
    
    
    self.viewControllers = @[nav,typeNav,searchNav,mineNav];
    self.selectedIndex = 0;
    
    [self customizeTabBarForController];
}

- (void)customizeTabBarForController
{
    UIImage * normalImage = [UIImage imageNamed:@"tabbar_bg_p"];
    NSArray * normalNames = @[@"recommend_p_n",@"channel_p_n",@"ranking_p_n",@"myqiyi_p_n"];
    RDVTabBar * tab = [self tabBar];
    tab.backgroundColor = [UIColor colorWithPatternImage:normalImage];
    NSInteger count = [[self tabBar] items].count;
    for (NSInteger i = 0; i < count; i++) {
        RDVTabBarItem * item = [[self tabBar] items][i];
        UIImage * normal =[UIImage imageNamed:normalNames[i]];
        NSString * str = normalNames[i];
        UIImage * selectImage = [UIImage imageNamed:[str stringByReplacingCharactersInRange:NSMakeRange(str.length-1, 1) withString:@"p"]];
        [item setBackgroundSelectedImage:selectImage withUnselectedImage:normal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
