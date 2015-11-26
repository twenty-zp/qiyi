//
//  AVPlayerVIew.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/25.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AVPlayerVIew : UIView

@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong,readonly)UIButton * backButton;
- (instancetype)initwithPlayUrl:(NSString *)urlPlayer;
- (void)deallocFromAVPlayer;
@end
