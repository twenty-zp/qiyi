//
//  ViewController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/4.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
{
    UIActivityIndicatorView * indicat;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    indicat = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicat.hidesWhenStopped = YES;
    [self.view addSubview:indicat];
    
    [indicat makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
- (void)startLoadingAnimation
{
    if (indicat) {
        [indicat startAnimating];
    }
}
- (void)stopLoadingAnimation
{
    if (indicat) {
        [indicat stopAnimating];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
