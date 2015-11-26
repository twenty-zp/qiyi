//
//  PlayerMovieController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//
static const CGFloat kVideoPlayerControllerAnimationTimeinterval = 0.3f;
#import "ZPPlayerControl.h"
#import "ZPPlayerViewController.h"
#import "ZPRequestClient.h"
#import "DownloadTask.h"
@interface ZPPlayerControl ()
{
    NSProgress *_progress;
    BOOL islock;
    double currentTime ;
    double totalTime ;
    CGFloat playWidth; //记录播放器的宽度
}
@property (nonatomic,strong)ZPPlayerViewController * playerView;


@property (nonatomic, strong) NSTimer *durationTimer;
@end
@implementation ZPPlayerControl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}
- (instancetype)init
{
    
    if (self == [super init]) {


        playWidth = [UIScreen mainScreen].bounds.size.width;
        self.controlStyle = MPMovieControlStyleNone;
//        self.shouldAutoplay = YES;
        
        [self.view addSubview:self.playerView];
        WS(ws);
        [self.playerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(0, 0, 0, 0))
            ;
        }];
        UIPanGestureRecognizer *leftSwipeGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];

     
        [self.playerView addGestureRecognizer:leftSwipeGestureRecognizer];

        
        [self configObserver];
        [self configControlAction];
    }
    return self;
}//https://www.vitamio.org/docs/Tutorial/2014/0211/30.html


- (void)handleSwipes:(UIPanGestureRecognizer *)sender
{
     CGPoint point = [sender translationInView:self.playerView];
   
    
    CGFloat x = point.x;

    double second = x/playWidth*60;
  
    if (sender.state == UIGestureRecognizerStateBegan) {
//     [self.durationTimer setFireDate:[NSDate distantFuture]];
        [self stopDurationTimer];
    }else if (sender.state == UIGestureRecognizerStateChanged)
    {
       
    
         currentTime = floor(self.currentPlaybackTime);
         totalTime = floor(self.duration);
        currentTime += second;
        if (currentTime > totalTime) {
            currentTime = totalTime;
        }else if (currentTime < 0.0){
            currentTime = 0.0;
        }
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self setTimeLabelValues:currentTime totalTime:totalTime];
            self.playerView.progressSlider.value = ceil(currentTime);
            [self setCurrentPlaybackTime:currentTime];
        }];
            [self performSelector:@selector(handleStartTimer) withObject:nil afterDelay:0.5];

       
      
      
    }
    
    
    
}
- (void)handleStartTimer
{
//         [self.durationTimer setFireDate:[NSDate date]];
    [self startDurationTimer];
}
- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    [super setContentURL:contentURL];
    [self prepareToPlay];
    [self play];
   
}

- (ZPPlayerViewController * )playerView
{
    if (!_playerView) {
        _playerView = [[ZPPlayerViewController alloc]initWithFrame:self.view.bounds];
        
    }
    return _playerView;
}
- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDeviceOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeDeviceOrientation:(NSNotification * )not
{
    if (islock) {
        return;
    }
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

    WS(ws);
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        if (ws.isfull) {
         
            [UIView animateWithDuration:0.25 animations:^{
                ws.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            }];
        }

    }else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        if (ws.isfull) {
          
            [UIView animateWithDuration:0.25 animations:^{
                ws.view.transform = CGAffineTransformRotate(ws.view.transform,M_PI);
            }];
        }
        
    }


}
- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        self.playerView.playerBtn.selected = YES;
        [self startDurationTimer];
        [self.playerView stopAnimation];
//        [self.playerView autoFadeOutControlBar];
    } else if (self.playbackState == MPMoviePlaybackStateStopped){
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
//            [self.videoControl animateShow];
        }
    }else if (self.playbackState == MPMoviePlaybackStatePaused)
    {
       
        [self stopDurationTimer];
    }
}
- (void)stopDurationTimer
{
    if (self.durationTimer.isValid) {
       [self.durationTimer invalidate];
    }
    
    
}
- (void)startDurationTimer
{
  
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
    [self.durationTimer fire];
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.playerView startAnimation];
    }else if (self.loadState & MPMovieLoadStatePlayable)
    {
        [self.playerView stopAnimation];
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}
- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)configControlAction
{
    [self.playerView.lockScreenBtn addTarget:self action:@selector(handlelockScreen:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.playerView.playerBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.playerView.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView.download addTarget:self action:@selector(downloadVideo:) forControlEvents:(UIControlEventTouchDown)];
    
    
     [self.playerView.backButton addTarget:self action:@selector(backNav:) forControlEvents:(UIControlEventTouchUpInside)];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}
- (void)handlelockScreen:(UIButton *)btn
{
    btn.selected =! btn.selected;
    islock = btn.selected;
}
- (void)backNav:(UIButton *)btn
{
                    if (_downloaded) {
                        _downloaded(0);
                    }
                    _downloaded = nil;
}
- (void)downloadVideo:(UIButton *)button
{
     button.selected = !button.selected;
     NSProgress * progress;
    
  
   DownloadTask * dTask = [[ZPSessionManager shareSessionManager] downloadUrl:@"http://dlsw.baidu.com/sw-search-sp/soft/07/25725/yy_mac_1.1.6.1434018013.dmg" progress:progress complete:^(NSURLResponse *data) {
            NSLog(@"data---%@",data);
            //        [progress removeObserver:self forKeyPath:@"fractionCompleted"];
        } error:^(NSError *error) {
            NSLog(@"error---%@",error);
            
        }];
      _progress = dTask.progress;
    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"])
    {
        NSProgress *progress = (NSProgress *)object;
        
                if ([_delegate respondsToSelector:@selector(handleProgress:)]) {
                    [_delegate handleProgress:progress.fractionCompleted];
                }
            NSLog(@"--%f",progress.fractionCompleted);

    }
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
//    [self.playerView autoFadeOutControlBar];
}
- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
//    [self.playerView cancelAutoFadeOutControlBar];
}
- (void)progressSliderValueChanged:(UISlider *)slider
{
    
     currentTime = floor(slider.value);
     totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}
- (void)playButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [self play];
    }else
    {
        [self pause];
    }
}
- (void)monitorVideoPlayback
{
//    //为了防止快进/快退 Slider回跳
    if (!self.durationTimer.isValid) {
        return;
    }
     currentTime = floor(self.currentPlaybackTime);
     totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.playerView.progressSlider.value = ceil(currentTime);
}
- (void)setProgressSliderMaxMinValues
{
    NSTimeInterval duration = self.duration;
    self.playerView.progressSlider.minimumValue = 0.0;
    self.playerView.progressSlider.maximumValue = duration;
}

- (void)setTimeLabelValues:(double)currentT totalTime:(double)totalT {
    double minutesElapsed = floor(currentT / 60.0);
    double secondsElapsed = fmod(currentT, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalT / 60.0);;
    double secondsRemaining = floor(fmod(totalT, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.playerView.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}
- (void)fullScreenButtonClick:(UIButton *)btn
{
    
    self.isfull =!self.isfull;
    [[UIApplication sharedApplication]setStatusBarHidden:self.isfull];
    if (_isfull) {
        [self handleFullScreen];
    }else
    {
        [self handleShrinkScreen];
    }
}
- (void)handleFullScreen
{
    
    UIDeviceOrientation orinentation = [UIDevice currentDevice].orientation;
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    
    playWidth = width;
    WS(ws);
    [UIView animateWithDuration:0.3f animations:^{
        
        [ws.view remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
            make.center.equalTo(ws.view.superview);
        }];
       
        if (orinentation == UIDeviceOrientationLandscapeRight) {
            [ws.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }else
        {
            [ws.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }
        
        
    } completion:nil];
}
- (void)handleShrinkScreen
{
    
    WS(ws);
    playWidth = [[UIScreen mainScreen] bounds].size.width;
    [UIView animateWithDuration:0.25 animations:^{
        ws.view.transform = CGAffineTransformIdentity;
        [ws.view remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view.superview);
            make.left.equalTo(ws.view.superview);
            make.height.greaterThanOrEqualTo(@(250));
            make.width.greaterThanOrEqualTo(ws.view.superview);
        }];
    }];
}
@end
