//
//  PlayerMovieController.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface ZPPlayerControl : MPMoviePlayerController
- (instancetype)init;

- (void)showInWindow;

@property (nonatomic,copy) void(^downloaded)(double progressValue);
@property (nonatomic,assign)BOOL isfull;

@property (nonatomic,assign)id delegate;
@end

@protocol ZPPlayerControlDelegate <NSObject>

- (void)handleProgress:(double)progressValue;

@end