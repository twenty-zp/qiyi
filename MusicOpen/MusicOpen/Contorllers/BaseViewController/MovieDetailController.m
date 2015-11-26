//
//  PlayerMovieController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "MovieDetailController.h"

#import "PlayerView/ZPPlayerControl.h"
#import "KxMovieViewController.h"
#import "AVPlayerVIew.h"
@implementation MovieDetailController
{
    AVPlayerVIew * _playerView;
     UIProgressView * progressView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor whiteColor]; //为了push页面不卡顿
    

    //添加播放器
    [self addPlayerView];

   
   //添加一个进度条 下载。针对的是MPMoviewController
    progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 350, self.view.frame.size.width - 40, 30)];
    progressView.progressTintColor=[UIColor blueColor];
    progressView.progress = 0.0;

    [progressView setTrackTintColor:[UIColor grayColor]];
    [self.contentView addSubview:progressView];
    
    
    __weak typeof(MovieDetailController *) ws = self;
//    _playerView.downloaded = ^(double progressValue)
//    {
//        [ws.navigationController popViewControllerAnimated:YES];
//    };
    //添加详情内容
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)addPlayerView
{
//    ZPPlayerControl * playerView = [[ZPPlayerControl alloc]init];
//    playerView.contentURL = [NSURL URLWithString:_playlink];
//    playerView.delegate = self;
//
//    [self.contentView addSubview:playerView.view];

    
 
//    KxMovieViewController * playerView = [KxMovieViewController movieViewControllerWithContentPath:_playlink parameters:nil];
//    playerView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
//
//    [self.view addSubview:playerView.view];
//    [self addChildViewController:playerView];
    
    AVPlayerVIew * playerView = [[AVPlayerVIew alloc]initwithPlayUrl:_playlink];
    [playerView.backButton addTarget:self action:@selector(handleBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:playerView];
    
      _playerView = playerView;
    WS(ws);
    [playerView makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView);
        make.height.greaterThanOrEqualTo(@(250));
        make.width.greaterThanOrEqualTo(ws.contentView);
    }];
}
- (void)handleBack
{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleProgress:(double)progressValue
{
    dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progressValue;
    });

   
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
- (void)dealloc
{
//    if (_playerView.playbackState == MPMoviePlaybackStatePlaying) {
//        [_playerView stop];
//    }
     [_playerView deallocFromAVPlayer];
    _playerView = nil;
}
@end
