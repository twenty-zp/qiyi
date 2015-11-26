//
//  AVPlayerVIew.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/25.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "AVPlayerVIew.h"

#import "ZPSlider.h"
@interface AVPlayerVIew ()
{
    NSTimer * timer;
    
    BOOL isShow;
    NSTimeInterval loadbuffed; //已经加载的数据
}

@property (nonatomic,strong)AVPlayer * player;
@property (strong, nonatomic) UIButton *playOrPause; //播放/暂停按钮

@property (nonatomic,strong)UIView * containView;
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)ZPSlider * progressSlider;
@property (nonatomic,strong)UIProgressView * progressView;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * allTimeLabel;
@property (nonatomic,strong)UIButton * shrikBtn;
@property (nonatomic,strong)UIButton * backButton;


@property (nonatomic, weak) id timeObserver;
//@property (nonatomic,strong)MaskView * maskLayer;
@end
@implementation AVPlayerVIew

+ (Class)layerClass
{
    return [AVPlayerLayer class] ;
}
- (void)deallocFromAVPlayer
{
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player removeTimeObserver:self.timeObserver];
    

    if (_player.rate == 1.0) {
        [_player pause];
        [self stopTimer];
        _player = nil;
    }

}
- (instancetype)initwithPlayUrl:(NSString *)urlPlayer
{
    if (self == [super init]) {
        _url = urlPlayer;
        
        isShow  = YES;
        
        [self setupUI];

        [self.player play];
        
        [self addGesture];
    }
    return self;
}
- (void)addGesture
{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    pan.maximumNumberOfTouches = 1 ;
    pan.minimumNumberOfTouches = 1;
    [self.containView addGestureRecognizer:pan];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.containView addGestureRecognizer:tap];
}

#pragma mark - 添加手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint p = [pan translationInView:self.containView];
    double currentTime = CMTimeGetSeconds(self.player.currentTime);
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (p.x > 0) {
            currentTime += 10.0;
            CMTime time = CMTimeMake(currentTime, 1);
            [self.player seekToTime:time];
            
        }else
        {
            currentTime -= 10.0;
            CMTime time = CMTimeMake(currentTime, 1);
            [self.player seekToTime:time];
            
        }
    }
   
    
}
- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    if (isShow) {
        isShow = NO;
        [self hiddenSubViews];
    }else
    {
        isShow = YES;
        [self showSubViews];
    }
}
#pragma mark - 隐藏
- (void)hiddenSubViews
{
    [UIView animateWithDuration:0.5 animations:^{
        _topView.hidden = YES;
        _bottomView.hidden = YES;
    }];
}

- (void)showSubViews
{
    [UIView animateWithDuration:0.5 animations:^{
        _topView.hidden = NO;
        _bottomView.hidden = NO;
    }];
}
- (void)setupUI
{
    AVPlayerLayer * layer = (AVPlayerLayer *)self.layer;
    layer.player = self.player;
    layer.videoGravity = AVLayerVideoGravityResize;
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    WS(ws);
    
    
    [self addSubview:self.containView];
    [_containView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws);
    }];
    //topView
    [self.containView addSubview:self.topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws);
        make.top.equalTo(ws).offset(20);
        make.height.equalTo(@45);
    }];
    [self.topView addSubview:self.backButton];
    [_backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws);
        make.centerY.equalTo(ws.topView.centerY);
        make.width.height.equalTo(@(40));
    }];
    //bottomView
    [self.containView addSubview:self.bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws);
        make.height.equalTo(@45);
    }];
    
    //播放按钮
    [self.bottomView addSubview:self.playOrPause];
    [self.bottomView addSubview:self.allTimeLabel];

    //进度条
    [self.bottomView addSubview:self.progressView];
    [self.progressView addSubview:self.progressSlider];
    
    //时间
    [self.bottomView addSubview:self.timeLabel];
    //放大缩小
    [self.bottomView addSubview:self.shrikBtn];
    
    [_playOrPause makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.bottomView);
        make.centerY.equalTo(ws.bottomView);
        make.width.height.equalTo(@40);
    }];
  
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.playOrPause.right).offset(5);
        make.right.equalTo(ws.progressView.left).offset(-5);
        make.centerY.equalTo(ws.playOrPause);
        make.width.equalTo(@35);
    }];
    
    [_progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.timeLabel.right).offset(5);
        make.centerY.equalTo(_playOrPause);
        make.right.equalTo(ws.allTimeLabel.left).offset(-5);
    }];
    
    [_progressSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws.progressView);
        make.centerY.equalTo(ws.progressView.centerY);
    }];
    
    [_allTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.progressView.right).offset(5);
        make.right.equalTo(ws.shrikBtn.left).offset(-5);
        make.centerY.equalTo(ws.playOrPause);
    }];
    
    [_shrikBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.allTimeLabel.right).offset(5);
        make.right.equalTo(ws);
        make.centerY.equalTo(ws.bottomView.centerY);
        make.width.height.equalTo(@(40));
    }];
    
    

}
- (UIButton *)playOrPause
{
    if (!_playOrPause) {
        _playOrPause = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _playOrPause.contentMode = UIViewContentModeCenter;
        [_playOrPause setImage:[self handleBundleName:@"kr-video-player-pause"] forState:UIControlStateNormal];
        [_playOrPause setImage:[self handleBundleName:@"kr-video-player-play"] forState:UIControlStateSelected];
        [_playOrPause addTarget:self action:@selector(playClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _playOrPause;
}

- (UIView *)containView
{
    if (!_containView) {
        _containView = [[UIView alloc]init];
//        _containView.backgroundColor = [UIColor yellowColor];
    }
    return _containView;
}
#pragma mark - topView
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
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
#pragma mark - bottomView
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d ",0,0];
    }
    return _timeLabel;
}
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _progressView.progress = 0.0;
    }
    return _progressView;
}
- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[ZPSlider alloc]init];
        _progressSlider.continuous = YES;
        [_progressSlider setThumbImage:[self handleBundleName:@"kr-video-player-point"] forState:(UIControlStateNormal)];
        _progressSlider.value = 0.0;
        _progressSlider.minimumValue = 0;
    }
    return _progressSlider;
}

- (UILabel *)allTimeLabel
{
    if (!_allTimeLabel) {
        _allTimeLabel = [[UILabel alloc]init];
        _allTimeLabel.textColor = [UIColor whiteColor];
        _allTimeLabel.font = [UIFont systemFontOfSize:10];
        _allTimeLabel.text = [NSString stringWithFormat:@" %02d:%02d",0,0];
    }
    return _allTimeLabel;
}
- (UIButton *)shrikBtn
{
    if (!_shrikBtn) {
        _shrikBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shrikBtn  setImage:[self handleBundleName:@"kr-video-player-fullscreen"] forState:(UIControlStateNormal)];
        [_shrikBtn  setImage:[self handleBundleName:@"kr-video-player-shrinkscreen"] forState:(UIControlStateSelected)];
        [_shrikBtn addTarget:self action:@selector(handleShirkView:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shrikBtn;
}
- (void)playClick:(UIButton *)sender {
    //    AVPlayerItemDidPlayToEndTimeNotification
    //AVPlayerItem *playerItem= self.player.currentItem;
    sender.selected = !sender.selected;
    if (sender.selected) { //正在播放
        [self stopTimer];
        [self.player pause];
     
    }else ///说明时暂停
    {
        [self startTimer];
        [self.player play];
        
    }
    
}

-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    ZPSlider *slider=self.progressSlider;
    //这里设置每秒执行一次
    self.timeObserver =[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
//        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
//            [progress setProgress:(current/total) animated:YES];
            [slider setValue:ceil(current) animated:YES];
        }
    }];
}

- (void)handleShirkView:(UIButton *)sender
{
    sender.selected =!sender.selected;
}
- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem * playerItem = [self getplayerItem];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}
- (AVPlayerItem *)getplayerItem
{
    NSURL * pleyerUrl = [NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:pleyerUrl];
    return item;
}

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    [timer fire];
}
- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}
- (void)handleTimer
{
    NSInteger currentSecond = CMTimeGetSeconds(_player.currentTime);
//    [_progressSlider setValue:currentSecond animated:YES];

    NSMutableString * mutStr = [NSMutableString string];
    if (currentSecond/3600 > 0) {
        [mutStr appendFormat:@"%02ld:",currentSecond/3600];
    }
    
    [mutStr appendFormat:@"%02ld:",currentSecond/60];
    [mutStr appendFormat:@"%02ld",currentSecond%60];
    
    _timeLabel.text = mutStr;
   
}
/**
 *  添加播放器通知
 */
//-(void)addNotification{
//    //给AVPlayerItem添加播放完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
//}
- (void)addObserverToPlayerItem:(AVPlayerItem *)item
{
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
       
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSMutableString * mutStr = [NSMutableString string];
            NSInteger second = ceil(CMTimeGetSeconds(playerItem.duration));
            if (second/3600 > 0) {
                [mutStr appendFormat:@"%02ld:",second/3600];
            }
            [mutStr appendFormat:@"%02ld:",second/60];
            [mutStr appendFormat:@"%02ld",second%60];
            _progressSlider.maximumValue = second;
            _allTimeLabel.text = mutStr;
            [self startTimer];
        }else if (status == AVPlayerStatusFailed)
        {
            
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
     
        
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        

        if (loadbuffed <= totalBuffer && _progressSlider.maximumValue > 1.0 && totalBuffer > 0.0) {
            
            //缓冲进度
         [_progressView setProgress:totalBuffer/(_progressSlider.maximumValue) animated:YES];
         
        }
       loadbuffed = totalBuffer;
    
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (UIImage *)handleBundleName:(NSString *)imageName
{
    if (imageName) {
        imageName = [NSString stringWithFormat:@"PlayerImage.bundle/%@",imageName];
        UIImage * image = [UIImage imageNamed:imageName];
        return image;
    }
    return  nil;
}
@end
