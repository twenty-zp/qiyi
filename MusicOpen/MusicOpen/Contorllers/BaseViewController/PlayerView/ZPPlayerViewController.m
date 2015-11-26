//
//  ZPPlayerViewController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPPlayerViewController.h"


static const CGFloat kZPPlayerVideoSound = 5;
static const CGFloat kZPPlayerTimeFontSize = 80.0;
static const CGFloat kZPPlayerBarAutoFadeOutTimeInterval = 0.5;
static const CGFloat kZPPlayerBarHeight = 40.0;

@interface ZPPlayerViewController ()
{
    BOOL isBarShowing;
}
@property (nonatomic,strong)UIView     *topBar;

@property (nonatomic,strong)UIView     *bottomBar;

@property (nonatomic,strong)UIButton   *playerBtn;
@property (nonatomic,strong)UISlider   *progressSlider;

@property (nonatomic,strong)UIButton   *fullScreenBtn;

@property (nonatomic,strong)UILabel    *timeLabel;

@property (nonatomic,strong)UIActivityIndicatorView * indicatorView;

@property (nonatomic,strong)UIButton   *download;
@property (nonatomic,strong)UIButton   *backButton;


@property (nonatomic,strong)UIButton   *lockScreenBtn;
@end
@implementation ZPPlayerViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tapgesture =   [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapgesture];
    

        [self setup];
    }
    return self;
}
- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (isBarShowing) {
            [self animateHide];
        }else
        {
            [self animateShow];
        }
    }
}


- (void)setup
{
    [self  addSubview:self.topBar];
    [self  addSubview:self.bottomBar];
    [self addSubview:self.lockScreenBtn];
    [self addSubview:self.indicatorView];
    
    [self.topBar addSubview:self.backButton];
    [self.bottomBar addSubview:self.playerBtn];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    [self.bottomBar addSubview:self.fullScreenBtn];
    [self.bottomBar addSubview:self.download]; 
    WS(ws);
    [_topBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws);
        make.top.equalTo(ws);
        make.height.equalTo(@(kZPPlayerBarHeight+20));
    }];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws);
        make.height.equalTo(@(kZPPlayerBarHeight));
    }];
    
    
    [_lockScreenBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws);
        make.centerY.equalTo(ws.centerY);
        make.width.height.equalTo(@(40));
    }];
    
    [_backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBar);
        make.top.equalTo(_topBar).offset(20);
        make.size.mas_equalTo(CGSizeMake(kZPPlayerBarHeight, kZPPlayerBarHeight));
    }];
    
    [_playerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_bottomBar);
        make.size.mas_equalTo(CGSizeMake(kZPPlayerBarHeight, kZPPlayerBarHeight));
    }];
    
    [_progressSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerBtn.right);
        make.centerY.equalTo(_bottomBar.centerY);
        make.right.equalTo(_timeLabel.left);
    }];
    
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressSlider.right);
        make.bottom.top.equalTo(_bottomBar);
        make.right.equalTo(_download.left);
    }];
    [_download makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.right);
        make.top.equalTo(_bottomBar);
        make.size.mas_equalTo(CGSizeMake(kZPPlayerBarHeight, kZPPlayerBarHeight));
    }];
    
    [_fullScreenBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_download.right);
        make.right.equalTo(_bottomBar);
        make.top.equalTo(_bottomBar);
        make.size.mas_equalTo(CGSizeMake(kZPPlayerBarHeight, kZPPlayerBarHeight));
    }];
    [_indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGFloat w = self.bounds.size.width;
//    self.topBar.frame = CGRectMake(0, 0,w , kZPPlayerBarHeight);
//    self.backButton.frame = CGRectMake(0, 0, kZPPlayerBarHeight, kZPPlayerBarHeight);
//    
//    self.indicatorView.center = self.center;
//    
//    //bottomBar y-轴
//    CGFloat y = self.bounds.size.height - kZPPlayerBarHeight;
//    
//    self.bottomBar.frame = CGRectMake(0, y, w, kZPPlayerBarHeight);
//    
//    self.playerBtn.frame = CGRectMake(0, 0, kZPPlayerBarHeight, kZPPlayerBarHeight);
//    
//    w = [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.playerBtn.frame)- kZPPlayerTimeFontSize -20 - 2*kZPPlayerBarHeight;
//    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playerBtn.frame)+5,kZPPlayerBarHeight/2,w, 5);
//    
//    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.progressSlider.frame)+5, 0, kZPPlayerTimeFontSize, kZPPlayerBarHeight);
//    
//    self.download.frame  = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+5, 0, kZPPlayerBarHeight, kZPPlayerBarHeight);
//    self.fullScreenBtn.frame = CGRectMake(CGRectGetMaxX(self.download.frame)+5, 0, kZPPlayerBarHeight, kZPPlayerBarHeight);
//}
- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
//        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _topBar;
}

- (UIButton *)lockScreenBtn
{
    if (!_lockScreenBtn)
    {
        _lockScreenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_lockScreenBtn setImage:[UIImage imageNamed:@"lock0"] forState:(UIControlStateNormal)];
        [_lockScreenBtn setImage:[UIImage imageNamed:@"lock1"] forState:(UIControlStateSelected)];
    }
    return _lockScreenBtn;
}
- (void)startAnimation
{
    if (_indicatorView) {
        [_indicatorView startAnimating];
    }
}

- (void)stopAnimation
{
    if (_indicatorView) {
        [_indicatorView stopAnimating];
    }
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    isBarShowing = YES;
}
- (void)animateHide
{
    if (isBarShowing) {
        isBarShowing = NO;
    }
    [UIView animateWithDuration:kZPPlayerBarAutoFadeOutTimeInterval animations:^{
        self.bottomBar.alpha = 0.0;
    }];
}
- (void)animateShow
{
    if (!isBarShowing) {
        isBarShowing = YES;
    }
    [UIView animateWithDuration:kZPPlayerBarAutoFadeOutTimeInterval animations:^{
        self.bottomBar.alpha = 1.0;
    }];
}
- (UIActivityIndicatorView * )indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}


- (UIButton *)backButton
{
    if (!_backButton) {
        UIButton * back = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [back setImage:[UIImage imageNamed:@"nav_backbtn"] forState:(UIControlStateNormal)];
        
        _backButton = back;
    }
  

    return _backButton;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    }
    return _bottomBar;
}
- (UIButton *)playerBtn
{
    if (!_playerBtn)
    {
        _playerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _playerBtn.contentMode = UIViewContentModeCenter;
        [_playerBtn setImage:[UIImage imageNamed:[self handleBundleName:@"kr-video-player-play"]] forState:(UIControlStateNormal)];
        [_playerBtn setImage:[UIImage imageNamed:[self handleBundleName:@"kr-video-player-pause"]] forState:(UIControlStateSelected)];
        
    }
    return _playerBtn;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_fullScreenBtn setImage:[UIImage imageNamed:[self handleBundleName:@"kr-video-player-fullscreen"]] forState:(UIControlStateNormal)];
        _fullScreenBtn.contentMode = UIViewContentModeCenter;
        [_fullScreenBtn setImage:[UIImage imageNamed:[self handleBundleName:@"kr-video-player-shrinkscreen"]] forState:(UIControlStateSelected)];
    }
    return _fullScreenBtn;
}
- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [UISlider new];
        [_progressSlider setThumbImage:[UIImage imageNamed:[self handleBundleName:@"kr-video-player-point"]] forState:(UIControlStateNormal)];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}
- (NSString *)handleBundleName:(NSString *)imageName
{
    if (imageName) {
        imageName = [NSString stringWithFormat:@"PlayerImage.bundle/%@",imageName];
        return imageName;
    }
    return  nil;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
//        _timeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",0.0,0.0];
        _timeLabel.bounds = CGRectMake(0, 0, kZPPlayerTimeFontSize, kZPPlayerTimeFontSize);
    }
    return _timeLabel;
}
- (UIButton *)download
{
    if (!_download) {
        _download = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_download setImage:[UIImage imageNamed:@"download_ic_pic_download"] forState:(UIControlStateNormal)];
    }
    return _download;
}
@end
