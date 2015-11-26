
//
//  MainController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/4.
//  Copyright © 2015年 zp. All rights reserved.
//推荐

#import "MainController.h"
#import "SearchButton.h"
#import "ZPRequestClient.h"

#import "ShowCategory.h"

#import "ContentViewController.h"
@interface MainController ()
{
    ContentViewController * contentView;
    NSMutableArray * dataArrs;
}
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArrs = [NSMutableArray  array];
    //自定义NavView
    [self customNavView];
    //添加内容
    [self addContentView];
    
    //请求数据
    [self requestData];
  
}
- (void)requestData
{
  
    [[ZPRequestClient shareClient] requestJsonDataWithPath:@"schemas/show/category.json" withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {

        if (data) {
            NSArray * categories = [data objectForKey:@"categories"];
            
            if (categories.count) {
                for (NSDictionary * dic in categories) {
                    ShowCategory * show = [ShowCategory objectWithKeyValues:dic];
                    [dataArrs addObject:show];
                }
                   contentView.datas = (NSArray *)dataArrs;
            }
        }
    }];
}
- (void)customNavView
{
    //图片
    UIImage * image = [UIImage imageNamed:@"player_homemadeview_top"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem * imageItem = [[UIBarButtonItem alloc]initWithCustomView:imageView];

  
    
    //搜索框
    
    SearchButton  * search = [SearchButton buttonWithType:(UIButtonTypeCustom)];
    search.bounds = CGRectMake(0, 20, 200, 30);
    [search setTitle:@"搜全网" forState:(UIControlStateNormal)];
    [search setImage:[UIImage imageNamed:@"QYSearch_icon"] forState:(UIControlStateNormal)];
    [search setBackgroundImage:[UIImage imageNamed:@"adtime_bg"] forState:(UIControlStateNormal)];
  
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:search];

    self.navigationItem.leftBarButtonItems = @[imageItem,searchItem];
    
   
    //历史记录
    UIImage * historyImage = [UIImage imageNamed:@"download_ic_pic_wait"];
    UIButton *  history = [UIButton buttonWithType:(UIButtonTypeCustom)];
    history.bounds = CGRectMake(0, 0, 40, 40);
    [history setImage:historyImage forState:(UIControlStateNormal)];
    UIBarButtonItem * historyItem = [[UIBarButtonItem alloc]initWithCustomView:history];
 
    
    //下载
    UIImage * downImage = [UIImage imageNamed:@"download_ic_pic_download"];
    UIButton *  downBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    downBtn.bounds = CGRectMake(0, 0, 40, 40);
    [downBtn setImage:downImage forState:(UIControlStateNormal)];
    UIBarButtonItem * downItem = [[UIBarButtonItem alloc]initWithCustomView:downBtn];
    self.navigationItem.rightBarButtonItems = @[downItem,historyItem];
    
}
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
- (void)addContentView
{
    contentView  = [[ContentViewController alloc]init];
    [self.view addSubview:contentView.view];
    [self addChildViewController:contentView];
    WS(ws);
    [contentView.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.view).offset(0);
        make.top.equalTo(ws.view).offset(-64);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
