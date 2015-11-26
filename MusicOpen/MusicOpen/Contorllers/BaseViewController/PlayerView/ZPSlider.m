//
//  ZPSlider.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/26.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPSlider.h"

@implementation ZPSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setMaximumTrackImage:transparentImage forState:(UIControlStateNormal)];
    [self setMinimumTrackImage:transparentImage forState:(UIControlStateNormal)];
}


@end
