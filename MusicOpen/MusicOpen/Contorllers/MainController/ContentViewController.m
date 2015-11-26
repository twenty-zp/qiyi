//
//  ContentViewController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ContentViewController.h"
#import "ShowCategory.h"
#import "MovieController.h"
#import "TVController.h"
@interface ContentViewController ()<ViewPagerDataSource,ViewPagerDelegate>
{
    NSMutableArray * array;
}
@end
@implementation ContentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    array = [NSMutableArray array];
    
//  
//    TVController * tv = [[TVController alloc]init];
//    [array addObject:tv];
    

    self.dataSource = self;
    self.delegate = self;
    
}
- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    for (NSInteger i = 0; i < _datas.count; i++) {
        MovieController * v = [[MovieController alloc]init];
        [array addObject:v];
    }
    [self reloadData];
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return _datas.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel * label = [UILabel new];
    ShowCategory * show = _datas[index];
    label.text = show.label;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];

    return label;
}
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    MovieController * movie = array[index];
    
    movie.category = _datas[index];
    return movie;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor cyanColor];
            break;
            
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
}
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

@end
